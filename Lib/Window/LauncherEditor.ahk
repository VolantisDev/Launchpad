/**
    This GUI edits a GameLauncher object.

    Modes:
      - "config" - Launcher configuration is being edited
      - "build" - Launcher is being built and requires information
*/

class LauncherEditor extends FormWindow {
    contentWidth := 500
    launcherGameObj := ""
    mode := "save" ; Options: config, build
    missingFields := Map()
    knownGames := ""
    launcherTypes := ""
    gameTypes := ""
    tabHeight := 550

    __New(app, launcherGameObj, mode := "config", owner := "", windowKey := "") {
        this.launcherGameObj := launcherGameObj
        this.mode := mode

        if (owner == "") {
            owner := "MainWindow"
        }

        super.__New(app, "Launcher Editor", this.GetTextDefinition(), owner, windowKey, this.GetButtonsDefinition())
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
            buttondDefs := "*&Save|&Cancel"
        } else if (this.mode == "build") {
            buttonDefs := "*&Continue|&Skip"
        }

        return buttonDefs
    }

    GetTitle(title) {
        return super.GetTitle(this.launcherGameObj.Key . " - " . title)
    }

    Controls() {
        super.Controls()

        tabs := this.guiObj.Add("Tab3", "h" . this.tabHeight . " +0x100", ["General", "Sources", "Advanced"])

        tabs.UseTab("General", true)

        this.AddHeading("Game")
        ctl := this.guiObj.AddComboBox("vKey xs y+m w" . this.contentWidth, this.knownGames)
        ctl.Text := this.launcherGameObj.Key
        ctl.OnEvent("Change", "OnKeyChange")
        this.AddHelpText("Select an existing game from the API, or enter a custom game key to create your own. Use caution when changing this value, as it will change which data is requested from the API.")

        this.AddHeading("Display Name")
        ctl := this.guiObj.AddEdit("vDisplayName xs y+m w" . this.contentWidth, this.launcherGameObj.DisplayName)
        ctl.OnEvent("Change", "OnDisplayNameChange")
        this.AddHelpText("You can change the display name of the game if it differs from the key. The launcher filename will still be created using the key.")

        this.AddHeading("Launcher Type")
        chosen := this.GetItemIndex(this.launcherTypes, this.launcherGameObj.LauncherType)
        ctl := this.guiObj.AddDDL("vLauncherType xs y+m Choose" . chosen . " w" . this.contentWidth, this.launcherTypes)
        ctl.OnEvent("Change", "OnLauncherTypeChange")
        this.AddHelpText("This tells Launchpad how to interact with any launcher your game might require. If no specific options match, or your game doesn't have a separate launcher, simply choose 'default'.")
        
        this.AddHeading("Game Type")
        chosen := this.GetItemIndex(this.gameTypes, this.launcherGameObj.GameType)
        ctl := this.guiObj.AddDDL("vGameType xs y+m Choose" . chosen . " w" . this.contentWidth, this.gameTypes)
        ctl.OnEvent("Change", "OnGameTypeChange")
        this.AddHelpText("This tells Launchpad how to launch your game. Most games can use 'default', but some launchers support multiple game types.")

        tabs.UseTab("Sources", true)

        this.AddHeading("Game Icon")
        this.AddLocationBlock("IconFile", "Clear")
        this.AddHelpText("You can select either an .ico file or an .exe file to extract the icon from. An icon named " . this.launcherGameObj.Key . ".ico in the game asset directory will be auto-detected without adding it here.")

        this.AddHeading("Shortcut File")
        this.AddLocationBlock("ShortcutFile", "Clear")
        this.AddHelpText("You can select a shortcut file that launches the game, or the game's .exe file itself. Leave this empty to use a Run command instead.")

        this.AddHeading("Run Command")
        this.AddLocationBlock("RunCmd", "Clear")
        this.AddHelpText("Instead of a shortcut file, you can enter a command directly that will launch the game. Leave this empty if you are using a shortcut.")

        tabs.UseTab("Advanced", true)

        this.AddHeading("Use AHK Class")
    }

    AddLocationBlock(settingName, extraButton := "") {
        location := this.launcherGameObj.%settingName% ? this.launcherGameObj.%settingName% : "Not set"

        this.AddLocationText(location, settingName)

        btn := this.guiObj.AddButton("xs y+m w" . this.buttonSmallW . " h" . this.buttonSmallH, "Change")
        btn.OnEvent("Click", "OnChange" . settingName)

        btn := this.guiObj.AddButton("x+m yp w" . this.buttonSmallW . " h" . this.buttonSmallH, "Open")
        btn.OnEvent("Click", "OnOpen" . settingName)

        if (extraButton != "") {
            btn := this.guiObj.AddButton("x+m yp w" . this.buttonSmallW . " h" . this.buttonSmallH, extraButton)
            btn.OnEvent("Click", "On" . extraButton . settingName)
        }
    }

    AddLocationText(locationText, ctlName) {
        position := "xs y+m"

        this.guiObj.SetFont("Bold")
        this.guiObj.AddText("v" . ctlName . " " . position . " w" . this.contentWidth . " +0x200 c" . this.accentDarkColor, locationText)
        this.guiObj.SetFont()
    }

    Create() {
        super.Create()
        dataSource := this.app.DataSources.GetDataSource("api")
        this.knownGames := dataSource.ReadListing("games")
        this.launcherTypes := dataSource.ReadListing("types/launchers")
        this.gameTypes := dataSource.ReadListing("types/games")
    }

    GetItemIndex(arr, itemValue) {
        result := ""

        for index, value in arr {
            if (value == itemValue) {
                result := index
                break
            }
        }

        return result
    }

    OnKeyChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.launcherGameObj.Key := ctlObj.Value

        ; @todo If new game type doesn't offer the selected launcher type, change to the default launcher type
    }

    OnLauncherTypeChange(ctlObj, info) {
        this.launcherGameObj.LauncherType := ctlObj.Value

        ; @todo Change the launcher class as well
        ; @todo If new launcher type changes the game type, change it here
    }

    OnGameTypeChange(ctlObj, info) {
        this.launcherGameObj.GameType := ctlObj.Value

        ; @todo Change the game class as well
    }

    OnDisplayNameChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.launcherGameObj.DisplayName := ctlObj.Value
    }

    OnChangeIconFile(ctlObj, info) {
        
    }

    OnOpenIconFile(ctlObj, info) {

    }

    OnClearIconFile(ctlObj, info) {

    }

    OnChangeShortcutFile(ctlObj, info) {

    }

    OnOpenShortcutFile(ctlObj, info) {

    }

    OnClearShortcutFile(ctlObj, info) {

    }

    OnChangeRunCmd(ctlObj, info) {

    }

    OnOpenRunCmd(ctlObj, info) {

    }

    OnClearRunCmd(ctlObj, info) {

    }
}
