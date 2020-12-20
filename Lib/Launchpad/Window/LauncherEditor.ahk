/**
    This GUI edits a GameLauncher object.

    Modes:
      - "config" - Launcher configuration is being edited
      - "build" - Launcher is being built and requires information
*/

class LauncherEditor extends LaunchpadFormGuiBase {
    launcherEntityObj := ""
    mode := "config" ; Options: config, build
    missingFields := Map()
    knownGames := ""
    knownThemes := ""
    launcherTypes := ""
    gameTypes := ""
    margin := 6

    __New(app, launcherEntityObj, mode := "config", windowKey := "", owner := "", parent := "") {
        InvalidParameterException.CheckTypes("LauncherEditor", "launcherEntityObj", launcherEntityObj, "LauncherEntity", "mode", mode, "")
        this.launcherEntityObj := launcherEntityObj
        this.launcherEntityObj.StoreOriginal(true)
        this.mode := mode

        if (windowKey == "") {
            windowKey := "LauncherEditor"
        }

        if (owner == "") {
            owner := "MainWindow"
        }

        super.__New(app, "Launcher Editor", this.GetTextDefinition(), windowKey, owner, parent, this.GetButtonsDefinition())
    }

    GetTextDefinition() {
        text := ""

        if (this.mode == "config") {
            text := "The details entered here will be saved to your Launchers file and used for all future builds."
        } else if (this.mode == "build") {
            text := "The details entered here will be used for this build only."
        }

        return text
    }

    GetButtonsDefinition() {
        buttonDefs := ""

        if (this.mode == "config") {
            buttonDefs := "*&Save|&Cancel"
        } else if (this.mode == "build") {
            buttonDefs := "*&Continue|&Skip"
        }

        return buttonDefs
    }

    GetTitle(title) {
        return super.GetTitle(this.launcherEntityObj.Key . " - " . title)
    }

    DefaultCheckbox(fieldKey, entity := "") {
        if (entity == "") {
            entity := this.launcherEntityObj
        }

        checkedText := !entity.UnmergedConfig.Has(fieldKey) ? " Checked" : ""
        ctl := this.guiObj.AddCheckBox("vDefault" . fieldKey . " xs h25 y+m" . checkedText, "Default")
        ctl.OnEvent("Click", "OnDefault" . fieldKey)
        return ctl
    }

    Controls() {
        super.Controls()

        tabs := this.guiObj.Add("Tab3", " x" . this.margin . " w" . this.windowSettings["contentWidth"] . " +0x100", ["General", "Sources", "Advanced"])

        tabs.UseTab("General", true)
        this.AddComboBox("Key", "Key", this.launcherEntityObj.Key, this.knownGames, "Select an existing game from the API, or enter a custom game key to create your own. Use caution when changing this value, as it will change which data is requested from the API.")
        this.AddEntityTypeSelect("Launcher", "LauncherType", this.launcherEntityObj.ManagedLauncher.EntityType, this.launcherTypes, "LauncherConfiguration", "This tells Launchpad how to interact with any launcher your game might require. If your game's launcher isn't listed, or your game doesn't have a launcher, start with `"Default`".")
        this.AddEntityTypeSelect("Game", "GameType", this.launcherEntityObj.ManagedLauncher.ManagedGame.EntityType, this.gameTypes, "GameConfiguration", "This tells Launchpad how to launch your game. Most games can use 'default', but launchers can support different game types.")

        tabs.UseTab("Sources", true)
        this.AddLocationBlock("Icon", "IconSrc")
        this.AddSelect("Launcher Theme", "ThemeName", this.launcherEntityObj.ThemeName, this.knownThemes)
        ; @todo Add data source keys checkboxes
        ; @todo Add data source item key

        tabs.UseTab("Advanced", true)
        this.AddTextBlock("DisplayName", "Display Name", true, "You can change the display name of the game if it differs from the key. The launcher filename will still be created using the key.")

        tabs.UseTab()
    }

    AddComboBox(heading, field, currentValue, allItems, helpText := "") {
        this.AddHeading(heading)
        ctl := this.guiObj.AddComboBox("v" . field . " xs y+m w" . this.windowSettings["contentWidth"], allItems)
        ctl.Text := currentValue
        ctl.OnEvent("Change", "On" . field . "Change")

        if (helpText) {
            this.AddHelpText(helpText)
        }
    }

    AddEntityTypeSelect(heading, field, currentValue, allItems, buttonName := "", helpText := "") {
        ctl := this.AddSelect(heading, field, currentValue,  allItems)
        buttonW := 150

        if (buttonName) {
            this.AddButton("v" . buttonName . " x+m yp w" . buttonW . " h25", "Manage", "On" . buttonName)
        }

        if (helpText) {
            this.AddHelpText(helpText)
        }

        return ctl
    }

    AddSelect(heading, field, currentValue, allItems, helpText := "") {
        this.AddHeading(heading)
        buttonW := 150
        ;ctl := this.DefaultCheckbox("GameType", this.launcherEntityObj.ManagedLauncher.ManagedGame)
        ;ctl.GetPos(,,checkW)
        fieldW := this.windowSettings["contentWidth"] - buttonW - this.margin
        chosen := this.GetItemIndex(allItems, currentValue)
        ctl := this.guiObj.AddDDL("v" . field . " xs y+m Choose" . chosen . " w" . fieldW, allItems)
        ctl.OnEvent("Change", "On" . field . "Change")

        if (helpText) {
            this.AddHelpText(helpText)
        }
    }

    AddTextBlock(field, settingName, showDefaultCheckbox := false, helpText := "") {
        this.AddHeading(settingName)
        checkW := 0
        disabledText := ""

        if (showDefaultCheckbox) {
            ctl := this.DefaultCheckbox(field)
            ctl.GetPos(,,checkW)
            checkW := checkW + this.margin
            disabledText := this.launcherEntityObj.UnmergedConfig.Has(field) ? "" : " Disabled"
        }
        
        fieldW := this.windowSettings["contentWidth"] - checkW
        ctl := this.guiObj.AddEdit("v" . field . " x+m yp w" . fieldW . disabledText, this.launcherEntityObj.Config[field])
        ctl.OnEvent("Change", "On" . field . "Change")

        if (helpText) {
            this.AddHelpText(helpTExt)
        }

        return ctl
    }

    AddLocationBlock(heading, settingName, extraButton := "", showOpen := true) {
        this.AddHeading(heading)

        location := this.launcherEntityObj.%settingName% ? this.launcherEntityObj.%settingName% : "Not set"

        this.AddLocationText(location, settingName)

        buttonSize := this.themeObj.GetButtonSize("s", true)
        buttonDims := ""
        
        if (buttonSize.Has("h") and buttonSize["h"] != "auto") {
            buttonDims .= " h" . buttonSize["h"]
        }

        if (buttonSize.Has("w") and buttonSize["w"] != "auto") {
            buttonDims .= " w" . buttonSize["w"]
        }

        btn := this.AddButton("xs y+m" . buttonDims . " vChange" . settingName, "Change")

        if (showOpen) {
            btn := this.AddButton("x+m yp" . buttonDims . " vOpen" . settingName, "Open")
        }

        if (extraButton != "") {
            btn := this.AddButton("x+m yp" . buttonDims . " v" . extraButton . settingName, extraButton)
        }
    }

    AddLocationText(locationText, ctlName) {
        position := "xs y+m"

        ;this.guiObj.SetFont("Bold")
        this.guiObj.AddText("v" . ctlName . " " . position . " w" . this.windowSettings["contentWidth"] . " +0x200 c" . this.themeObj.GetColor("accentDark"), locationText)
        ;this.guiObj.SetFont()
    }

    Create() {
        super.Create()
        dataSource := this.app.DataSources.GetItem("api")
        this.knownGames := dataSource.ReadListing("Games")
        this.launcherTypes := dataSource.ReadListing("Types/Launchers")
        this.gameTypes := dataSource.ReadListing("Types/Games")
        this.knownThemes := this.app.Themes.GetAvailableThemes(true)
    }

    OnDefaultDisplayName(ctlObj, info) {
        return this.SetDefaultValue("DisplayName", !!(ctlObj.Value))
    }

    OnDefaultGameType(ctlObj, info) {
        return this.SetDefaultValue("GameType", !!(ctlObj.Value))
    }

    SetDefaultValue(fieldKey, useDefault := true) {
        if (useDefault) {
            this.launcherEntityObj.RevertToDefault(fieldKey)
            this.guiObj[fieldKey].Value := this.launcherEntityObj.Config[fieldKey]
        } else {
            this.launcherEntityObj.UnmergedConfig[fieldKey] := this.launcherEntityObj.Config.Has(fieldKey) ? this.launcherEntityObj.Config[fieldKey] : ""
        }

        this.guiObj[fieldKey].Enabled := !useDefault
    }

    ProcessResult(result) {
        if (result == "Save") {
            modifiedData := this.launcherEntityObj.GetModifiedData(true)
            this.launcherEntityObj.SaveModifiedData()
            return modifiedData
            ; Compare with original object, return differences in unmerged config
        } else {
            this.launcherEntityObj.RestoreFromOriginal()
            return Map()
        }
    }

    OnKeyChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.launcherEntityObj.Key := ctlObj.Value

        ; @todo If new game type doesn't offer the selected launcher type, change to the default launcher type
    }

    OnLauncherTypeChange(ctlObj, info) {
        this.launcherEntityObj.ManagedLauncher.EntityType := ctlObj.Value

        ; @todo Change the launcher class as well
        ; @todo If new launcher type changes the game type, change it here
    }

    OnGameTypeChange(ctlObj, info) {
        this.launcherEntityObj.ManagedLauncher.ManagedGame.EntityType := ctlObj.Value

        ; @todo Change the game class as well
    }

    OnLauncherConfiguration(ctlObj, info) {

    }

    OnGameConfiguration(ctlObj, info) {

    }

    OnDisplayNameChange(ctlObj, info) {
        this.guiObj.Submit(false)
        ;this.launcherEntityObj.DisplayName := ctlObj.Value
    }

    OnChangeIconFile(btn, info) {
        
    }

    OnOpenIconFile(btn, info) {

    }

    OnClearIconFile(btn, info) {

    }

    OnChangeShortcutFile(btn, info) {

    }

    OnOpenShortcutFile(btn, info) {

    }

    OnClearShortcutFile(btn, info) {

    }

    OnChangeRunCmd(btn, info) {

    }

    OnClearRunCmd(btn, info) {

    }

    OnChangeGameId(btn, info) {

    }

    OnHelpGameId(btn, info) {

    }

    OnUseAhkClass(chk, info) {

    }
}
