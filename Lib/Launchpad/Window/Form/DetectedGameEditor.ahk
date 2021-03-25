class DetectedGameEditor extends LaunchpadFormGuiBase {
    detectedGameObj := ""
    newValues := Map()
    missingFields := Map()
    dataSource := ""
    knownGames := ""
    launcherTypes := ""
    gameTypes := ""
 
    __New(app, detectedGameObj, title, windowKey := "", owner := "", parent := "") {
        InvalidParameterException.CheckTypes("DetectedGameEditor", "detectedGameObj", detectedGameObj, "DetectedGame")
        this.detectedGameObj := detectedGameObj

        if (windowKey == "") {
            windowKey := "DetectedGameEditor"
        }

        if (owner == "") {
            owner := "ManageWindow"
        }

        super.__New(app, title, this.GetTextDefinition(), windowKey, owner, parent, this.GetButtonsDefinition())
    }

    Create() {
        super.Create()
        this.dataSource := this.app.DataSources.GetItem("api")
        this.knownPlatforms := this.dataSource.ReadListing("platforms")
        this.knownGames := this.dataSource.ReadListing("game-keys")
        this.launcherTypes := this.dataSource.ReadListing("launcher-types")
        this.gameTypes := this.dataSource.ReadListing("game-types")
    }

    GetTextDefinition() {
        return "These values were detected automatically. You may customize them below. Blanking out a value will cause the entity to use the default (or retain its existing value)."
    }

    GetButtonsDefinition() {
        return "*&Save|&Cancel"
    }

    GetTitle(title) {
        return super.GetTitle(title . ": " . this.detectedGameObj.key)
    }

    DefaultCheckbox(fieldKey, entity := "", addPrefix := false) {
        if (entity == "") {
            entity := this.detectedGameObj
        }

        return super.DefaultCheckbox(fieldKey, entity, addPrefix)
    }

    Controls() {
        super.Controls()
        this.AddComboBox("Key", "Key", this.detectedGameObj.key, this.knownGames, "You can change the detected game key here, which will become the name of your launcher. Your existing launchers, and all launchers known about via the API, can be selected to match this game up with one of those items.")
        this.AddEntityTypeSelect("Launcher Type", "LauncherType", this.detectedGameObj.launcherType, this.launcherTypes, "", "This tells Launchpad how to interact with any launcher your game might require. If your game's launcher isn't listed, or your game doesn't have a launcher, start with `"Default`".`n`nYou can customize the details of the launcher type after it is added.")
        this.AddEntityTypeSelect("Game Type", "GameType", this.detectedGameObj.gameType, this.gameTypes, "", "This tells Launchpad how to launch your game. Most games can use 'default', but launchers can support different game types.`n`nYou can customize the details of the game type after it is added.")
        this.AddLocationBlock("Install Dir", "InstallDir", this.detectedGameObj.installDir, "", true, "This is the directory that the game is installed in, if it could be detected.")
        this.AddComboBox("Exe", "Exe", this.detectedGameObj.exeName, this.detectedGameObj.possibleExeNames, "The main Exe, if detected, should be pre-selected. You may change it to be the name (or path) of another exe, or select another one of the detected .exe files from the list (if more than one was found).")
        this.AddTextBlock("Launcher-Specific ID", "LauncherSpecificId", this.detectedGameObj.launcherSpecificId, "This is typically the ID which the game platform or launcher uses when referring to the game internally. Changing this value could cause issues with game launching.")
    }

    AddTextBlock(heading, field, existingVal := "", helpText := "") {
        this.AddHeading(heading)

        ctl := this.guiObj.AddEdit("v" . field . " xs y+m w" . this.windowSettings["contentWidth"] . " c" . this.themeObj.GetColor("editText"), existingVal)
        ctl.OnEvent("Change", "On" . field . "Change")

        if (helpText) {
            ctl.ToolTip := helpText
        }

        return ctl
    }

    AddLocationBlock(heading, field, location, extraButton := "", showOpen := true, helpText := "") {
        this.AddHeading(heading)
        ctl := this.AddLocationText(location, field, "xs y+m")

        if (helpText) {
            ctl.ToolTip := helpText
        }

        buttonSize := this.themeObj.GetButtonSize("s", true)
        buttonDims := ""
        
        if (buttonSize.Has("h") && buttonSize["h"] != "auto") {
            buttonDims .= " h" . buttonSize["h"]
        }

        if (buttonSize.Has("w") && buttonSize["w"] != "auto") {
            buttonDims .= " w" . buttonSize["w"]
        }

        btn := this.AddButton("xs y+m" . buttonDims . " vChange" . field, "Change")

        if (showOpen) {
            btn := this.AddButton("x+m yp" . buttonDims . " vOpen" . field, "Open")
        }

        if (extraButton != "") {
            btn := this.AddButton("x+m yp" . buttonDims . " v" . extraButton . field, extraButton)
        }
    }

    AddLocationText(locationText, ctlName, position := "xs y+m") {
        ;this.guiObj.SetFont("Bold")
        ctl := this.guiObj.AddText("v" . ctlName . " " . position . " w" . this.windowSettings["contentWidth"] . " +0x200 c" . this.themeObj.GetColor("linkText"), locationText)
        ;this.guiObj.SetFont()
        return ctl
    }

    OnKeyChange(ctl, info) {
        this.guiObj.Submit(false)
        this.newValues["key"] := ctl.Text
    }

    OnLauncherTypeChange(ctl, info) {
        this.guiObj.Submit(false)
        this.newValues["launcherType"] := ctl.Text
    }

    OnGameTypeChange(ctl, info) {
        this.guiObj.Submit(false)
        this.newValues["gameType"] := ctl.Text
    }

    GetValue(key) {
        val := this.detectedGameObj.%key%

        if (this.newValues.Has(key)) {
            val := this.newValues[key]
        }

        return val
    }

    OnChangeInstallDir(btn, info) {
        existingVal := this.GetValue("installDir")

        if (existingVal) {
            existingVal := "*" . existingVal
        }

        key := this.GetValue("key")
        dir := DirSelect(existingVal, 2, key . ": Select the installation directory")

        if (dir) {
            this.newValues["installDir"] := dir
            this.guiObj["InstallDir"].Text := dir
        }
    }

    OnOpenInstallDir(btn, info) {
        installDir := this.detectedGameObj.installDir

        if (this.newValues.Has("installDir")) {
            installDir := this.newValues["installDir"]
        }
        
        if (installDir && DirExist(installDir)) {
            Run(installDir)
        }
    }

    OnExeChange(ctl, info) {
        this.guiObj.Submit(false)
        this.newValues["exeName"] := ctl.Text
    }

    OnLauncherSpecificIdChange(ctl, info) {
        this.guiObj.Submit(false)
        this.newValues["launcherSpecificId"] := ctl.Text
    }

    ProcessResult(result) {
        if (result == "Save") {
            for key, value in this.newValues {
                this.detectedGameObj.%key% := value
            }
        }

        return result
    }
}
