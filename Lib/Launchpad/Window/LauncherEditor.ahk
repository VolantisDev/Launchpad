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
    launcherTypes := ""
    gameTypes := ""
    margin := 6

    __New(app, launcherEntityObj, mode := "config", windowKey := "", owner := "", parent := "") {
        InvalidParameterException.CheckTypes("LauncherEditor", "launcherEntityObj", launcherEntityObj, "LauncherEntity", "mode", mode, "")
        this.launcherEntityObj := launcherEntityObj
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
            ;buttonDefs := "*&Save|&Cancel"
        } else if (this.mode == "build") {
            ;buttonDefs := "*&Continue|&Skip"
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

        this.AddHeading("Key")
        ctl := this.guiObj.AddComboBox("vKey xs y+m w" . this.windowSettings["contentWidth"], this.knownGames)
        ctl.Text := this.launcherEntityObj.Key
        ctl.OnEvent("Change", "OnKeyChange")
        this.AddHelpText("Select an existing game from the API, or enter a custom game key to create your own. Use caution when changing this value, as it will change which data is requested from the API.")

        this.AddHeading("Launcher")
        buttonW := 150
        launcherTypeW :=  this.windowSettings["contentWidth"] - buttonW - this.margin
        chosen := this.GetItemIndex(this.launcherTypes, this.launcherEntityObj.ManagedLauncher.EntityType)
        ctl := this.guiObj.AddDDL("vLauncherType xs y+m Choose" . chosen . " w" . launcherTypeW, this.launcherTypes)
        ctl.OnEvent("Change", "OnLauncherTypeChange")
        this.AddButton("vLauncherConfiguration x+m yp w" . buttonW . " h25", "Manage", "OnLauncherConfiguration")
        this.AddHelpText("This tells Launchpad how to interact with any launcher your game might require. If your game's launcher isn't listed, or your game doesn't have a launcher, start with `"Default`".")

        this.AddHeading("Game")
        ;ctl := this.DefaultCheckbox("GameType", this.launcherEntityObj.ManagedLauncher.ManagedGame)
        ;ctl.GetPos(,,checkW)
        fieldW := this.windowSettings["contentWidth"] - buttonW - this.margin
        chosen := this.GetItemIndex(this.gameTypes, this.launcherEntityObj.ManagedLauncher.ManagedGame.EntityType)
        ctl := this.guiObj.AddDDL("vGameType xs y+m Choose" . chosen . " w" . fieldW, this.gameTypes)
        ctl.OnEvent("Change", "OnGameTypeChange")
        this.AddButton("vGameConfiguration x+m yp w" . buttonW . " h25", "Manage", "OnGameConfiguration")
        this.AddHelpText("This tells Launchpad how to launch your game. Most games can use 'default', but launchers can support different game types.")

        tabs.UseTab("Sources", true)

        ; Game exe
        ; Game window class
        ; Launcher exe
        ; Launcher window class

        ;this.AddHeading("Game ID")
        ;this.AddLocationBlock("GameId", "Help", false)
        ;this.AddHelpText("Usually the name of the game's .exe process, but this field can vary by launcher type. Click Help for more information.")

        ;this.AddHeading("Game Icon")
        ;this.AddLocationBlock("IconSrc", "Clear")
        ;this.AddHelpText("You can select either an .ico file or an .exe file to extract the icon from. An icon named " . this.launcherEntityObj.Key . ".ico in the game asset directory will be auto-detected without adding it here.")

        ;this.AddHeading("Shortcut File")
        ;this.AddLocationBlock("ShortcutFile", "Clear")
        ;this.AddHelpText("You can select a shortcut file that launches the game, or the game's .exe file itself. Leave this empty to use a Run command instead.")

        ;this.AddHeading("Run Command")
        ;this.AddLocationBlock("RunCmd", "Clear", false)
        ;this.AddHelpText("Instead of a shortcut file, you can enter a command directly that will launch the game. Leave this empty if you are using a shortcut.")

        tabs.UseTab("Advanced", true)

        ;this.AddHelpText("These settings can often be left at their default. A grayed-out checkboxes mean that the value will always be determined by the launcher type, game type, and/or API.")
        
        this.AddHeading("Display Name")
        ctl := this.DefaultCheckbox("DisplayName")
        ctl.GetPos(,,checkW)
        fieldW := this.windowSettings["contentWidth"] - checkW - this.margin
        ctl := this.guiObj.AddEdit("vDisplayName x+m yp w" . fieldW, this.launcherEntityObj.DisplayName)
        ctl.OnEvent("Change", "OnDisplayNameChange")
        this.AddHelpText("You can change the display name of the game if it differs from the key. The launcher filename will still be created using the key.")

        ;this.AddHeading("Working Directory")
        ;this.AddLocationBlock("WorkingDir", "Clear")
        ;this.AddHelpText("If needed, set the directory that the shortcut or Run command will be started from.")
        
        this.AddHeading("Additional Options")

        ;val := this.entityObj.ConfigIsSet("useAhkClass", false) ? this.entityObj.UseAhkClass : "Gray"
        ;this.AddCheckBox("Use AHK class", "UseAhkClass", val, false, "", true)

        ;val := this.entityObj.ConfigIsSet("supportsShortcut", false) ? this.entityObj.SupportsShortcut : "Gray"
        ;this.AddCheckBox("Launcher supports shortcut files", "SupportsShortcut", val, false, "", true)

        ;val := this.entityObj.ConfigIsSet("runThenWait", false) ? this.entityObj.RunThenWait : "Gray"
        ;this.AddCheckBox("Monitor game window to detect when it closes", "RunThenWait", val, false, "", true)

        ; WaitAfterClose
        ; How long to wait after attempting to close a launcher before launching the game
        
        ; WaitBehavior
        ; Whether to continually check after a delay, or prompt and wait, when closing a launcher
        ; sleep, prompt

        ; WaitSleep
        ; How long to wait between checks to see if the launcher is closed

        ; AutoKillLauncher
        ; Whether to automatically kill the launcher process after exiting the game, instead of waiting nicely

        ; AutoKillLauncherDelay
        ; How long to wait after killing the launcher

        ; CloseLauncherBeforeRun

        ; CloseLauncherAfterRun

        ; CloseLauncherDelay
        ; How long to wait after exiting a game before auto-killing the launcher, to leave time for syncing

        tabs.UseTab()
    }

    AddLocationBlock(settingName, extraButton := "", showOpen := true) {
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

        this.guiObj.SetFont("Bold")
        this.guiObj.AddText("v" . ctlName . " " . position . " w" . this.windowSettings["contentWidth"] . " +0x200 c" . this.themeObj.GetColor("accentDark"), locationText)
        this.guiObj.SetFont()
    }

    Create() {
        super.Create()
        dataSource := this.app.DataSources.GetItem("api")
        this.knownGames := dataSource.ReadListing("Games")
        this.launcherTypes := dataSource.ReadListing("Types/Launchers")
        this.gameTypes := dataSource.ReadListing("Types/Games")
    }

    OnDefaultDisplayName(ctlObj, info) {
        ;this.SetDefaultValue()
    }

    OnDefaultGameType(ctlObj, info) {
        ;this.SetDefaultValue()
    }

    SetDefaultValue(fieldKey, useDefault := true) {
        ; Get checkbox value

        ; Unset config if checked

        ; Gray out field and show default value if checked

        ; Enable field and copy default value to config if unchecked
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
