/**
    This GUI edits a GameLauncher object.

    Modes:
      - "config" - Launcher configuration is being edited
      - "build" - Launcher is being built and requires information
*/

class LauncherEditor extends LauncherEditorBase {
    __New(app, themeObj, windowKey, entityObj, mode := "config", owner := "", parent := "") {
        super.__New(app, themeObj, windowKey, entityObj, "Launcher Editor", mode, owner, parent)
    }

    GetButtonsDefinition() {
        buttonsDef := super.GetButtonsDefinition()
        buttonsDef .= "|S&imple"
        return buttonsDef
    }

    Controls() {
        super.Controls()
        tabs := this.guiObj.Add("Tab3", " x" . this.margin . " w" . this.windowSettings["contentWidth"] . " +0x100", ["General", "Sources", "UI", "Processes", "Advanced"])

        tabs.UseTab("General", true)
        this.AddComboBox("Key", "Key", this.entityObj.Key, this.knownGames, "Select an existing game from the API, or enter a custom game key to create your own. Use caution when changing this value, as it will change which data is requested from the API.")
        this.AddEntityCtl("Display Name", "DisplayName", true, "EditControl", 1, "", "You can change the display name of the game if it differs from the key. The launcher filename will still be created using the key.")
        this.AddEntityCtl("Platform", "Platform", false, "SelectControl", this.platforms, "")
        ctl := this.AddEntityCtl("Launcher", "LauncherType", false, "SelectControl", this.launcherTypes, "", "This tells " . this.app.appName . " how to interact with any launcher your game might require. If your game's launcher isn't listed, or your game doesn't have a launcher, start with `"Default`".", "Manage", "OnManageLauncherType")
        ctl.refreshOnDataChange := true
        ctl := this.AddEntityCtl("Game", "GameType", false, "SelectControl", this.gameTypes, "", "This tells " . this.app.appName . " how to launch your game. Most games can use 'default', but launchers can support different game types.", "Manage", "OnManageGameType")
        ctl.refreshOnDataChange := true

        tabs.UseTab("Sources", true)
        this.AddEntityCtl("Icon Source", "IconSrc", true, "LocationBlock", "IconSrc", "Clear", true)
        this.AddEntityCtl("DataSource Item Key", "DataSourceItemKey", true, "EditControl", 1, "", "The key to use when looking this item up in its datasource(s). By default, this is the same as the main key.")
        
        tabs.UseTab("UI", true)
        this.AddEntityCtl("Launcher Theme", "ThemeName", true, "SelectControl", this.knownThemes, "", "The theme to use if/when the launcher shows GUI windows")
        ctl := this.AddEntityCtl("", "ShowProgress", true, "BasicControl", "CheckBox", "Show Progress Window")
        ctl.ctl.ToolTip := "Whether or not to show a window indicating the current status of the launcher"
        this.AddEntityCtl("Progress Window Title", "ProgressTitle", true, "EditControl", 1, "", "The title that the progress window will use if shown")
        this.AddEntityCtl("Progress Window Text", "ProgressText", true, "EditControl", 1, "", "The text displayed at the top of the progress window if shown")

        tabs.UseTab("Processes", true)
        this.AddEntityCtl("Run Before Game", "RunBefore", true, "EditControl", 3, "", "Run one or more processes before launching the game. Each line should contain a command to run or a full path to a .exe or shortcut file to launch.`n`nEach process will be run as a scheduled task so that it is not owned by the launcher.")
        this.AddEntityCtl("Close Before Game", "CloseBefore", true, "EditControl", 3, "", "Close one or more processes before launching the game. Each line should contain the name of the process to close (usually just the .exe filename).")
        this.AddEntityCtl("Run After Game", "RunAfter", true, "EditControl", 3, "", "Run one or more processes after closing the game. Each line should contain a command to run or a full path to a .exe or shortcut file to launch.`n`nEach process will be run as a scheduled task so that it is not owned by the launcher.")
        this.AddEntityCtl("Close After Game", "CloseAfter", true, "EditControl", 3, "", "Close one or more processes after closing the game. Each line should contain the name of the process to close (usually just the .exe filename).")

        tabs.UseTab("Advanced", true)

        this.AddHeading("Logging Level")
        this.AddEntityCtl("Logging Level", "LoggingLevel", true, "SelectControl", this.logLevels)
        this.AddEntityCtl("Log Path", "LogPath", true, "LocationBlock", "LogPath", "Clear", true)

        tabs.UseTab()
    }
}
