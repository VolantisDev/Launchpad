class DetectedGameEditor extends FormGuiBase {
    detectedGameObj := ""
    newValues := Map()
    missingFields := Map()
    dataSource := ""
    knownGames := ""
    launcherTypes := ""
    gameTypes := ""
 
    __New(app, themeObj, windowKey, detectedGameObj, owner := "", parent := "") {
        InvalidParameterException.CheckTypes("DetectedGameEditor", "detectedGameObj", detectedGameObj, "DetectedGame")
        this.detectedGameObj := detectedGameObj
        super.__New(app, themeObj, windowKey, "Detected Game Editor", this.GetTextDefinition(), owner, parent, this.GetButtonsDefinition())
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
        this.AddEntityTypeSelect("Launcher Type", "LauncherType", this.detectedGameObj.launcherType, this.launcherTypes, "", "This tells " . this.app.appName . " how to interact with any launcher your game might require. If your game's launcher isn't listed, or your game doesn't have a launcher, start with `"Default`".`n`nYou can customize the details of the launcher type after it is added.")
        this.AddEntityTypeSelect("Game Type", "GameType", this.detectedGameObj.gameType, this.gameTypes, "", "This tells " . this.app.appName . " how to launch your game. Most games can use 'default', but launchers can support different game types.`n`nYou can customize the details of the game type after it is added.")
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
        btnWidth := 20
        btnHeight := 20
        ctl := this.AddLocationText(location, field, "xs y+m", this.windowSettings["contentWidth"] - btnWidth - (this.margin/2))

        if (helpText) {
            ctl.ToolTip := helpText
        }
    
        menuItems := []
        menuItems.Push(Map("label", "Change", "name", "Change" . field))

        if (showOpen) {
            menuItems.Push(Map("label", "Open", "name", "Open" . field))
        }

        if (extraButton) {
            menuItems.Push(Map("label", extraButton, "name", StrReplace(extraButton, " ", "") . field))
        }

        btn := this.AddButton("w" . btnWidth . " h" . btnHeight . " x+" (this.margin/2) . " yp", "arrowDown", "OnLocationOptions", "symbol")
        btn.MenuItems := menuItems
        btn.Tooltip := "Change options"
    }

    OnLocationOptions(btn, info) {
        this.app.GuiManager.Menu("MenuGui", btn.MenuItems, this, this.windowKey, "", btn)
    }

    AddLocationText(locationText, ctlName, position := "xs y+m", width := "") {
        if (!width) {
            width := this.windowSettings["contentWidth"]
        }

        ;this.guiObj.SetFont("Bold")
        ctl := this.guiObj.AddText("v" . ctlName . " " . position . " w" . width . " +0x200 c" . this.themeObj.GetColor("linkText"), locationText)
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

    ProcessResult(result, submittedData := "") {
        if (result == "Save") {
            for key, value in this.newValues {
                this.detectedGameObj.%key% := value
            }
        }

        return result
    }
}
