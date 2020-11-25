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

        this.AddHeading("Display Name")
        ctl := this.guiObj.AddEdit("vDisplayName xs y+m w" . this.contentWidth, this.launcherGameObj.DisplayName)
        ctl.OnEvent("Change", "OnDisplayNameChange")

        this.AddHeading("Launcher Type")
        chosen := this.GetItemIndex(this.launcherTypes, this.launcherGameObj.LauncherType)
        ctl := this.guiObj.AddDDL("vLauncherType xs y+m Choose" . chosen . " w" . this.contentWidth, this.launcherTypes)
        ctl.OnEvent("Change", "OnLauncherTypeChange")
        
        this.AddHeading("Game Type")
        chosen := this.GetItemIndex(this.gameTypes, this.launcherGameObj.GameType)
        ctl := this.guiObj.AddDDL("vGameType xs y+m Choose" . chosen . " w" . this.contentWidth, this.gameTypes)
        ctl.OnEvent("Change", "OnGameTypeChange")

        tabs.UseTab("Sources", true)

        this.AddHeading("Game Icon")
        this.AddLocationBlock("IconFile")

        this.AddHeading("Shortcut File")
        this.AddLocationBlock("ShortcutFile")

        this.AddHeading("Run Command")
        this.AddLocationBlock("RunCmd")

        tabs.UseTab("Advanced", true)
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

    OnChangeShortcutFile(ctlObj, info) {

    }

    OnOpenShortcutFile(ctlObj, info) {

    }

    OnChangeRunCommand(ctlObj, info) {

    }

    OnOpenRunCommand(ctlObj, info) {

    }
}
