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
        this.AddTextBlock("DisplayName", "Display Name", true, "You can change the display name of the game if it differs from the key. The launcher filename will still be created using the key.")
        
        this.AddSelect("Platform", "Platform", this.entityObj.Platform, this.platforms, false, "", "", "Select the platform that this game is run through.", false)

        this.AddEntityTypeSelect("Launcher", "LauncherType", this.entityObj.ManagedLauncher.EntityType, this.launcherTypes, "LauncherConfiguration", "This tells " . this.app.appName . " how to interact with any launcher your game might require. If your game's launcher isn't listed, or your game doesn't have a launcher, start with `"Default`".")
        this.AddEntityTypeSelect("Game", "GameType", this.entityObj.ManagedLauncher.ManagedGame.EntityType, this.gameTypes, "GameConfiguration", "This tells " . this.app.appName . " how to launch your game. Most games can use 'default', but launchers can support different game types.")

        tabs.UseTab("Sources", true)
        this.AddEntityCtl("IconSrc", "Icon Source", false, "LocationBlock", "", "", "IconSrc", "", "Clear", true)

        this.AddTextBlock("DataSourceItemKey", "DataSource Item Key", true, "The key to use when looking this item up in its datasource(s). By default, this is the same as the main key.")

        tabs.UseTab("UI", true)
        this.AddSelect("Launcher Theme", "ThemeName", this.entityObj.ThemeName, this.knownThemes, true, "", "", "The theme to use if/when the launcher shows GUI windows")
        this.AddCheckBoxBlock("ShowProgress", "Show Progress Window", true, "Whether or not to show a window indicating the current status of the launcher")
        this.AddTextBlock("ProgressTitle", "Progress Window Title", true, "The title that the progress window will use if shown")
        this.AddTextBlock("ProgressText", "Progress Window Text", true, "The text displayed at the top of the progress window if shown")

        tabs.UseTab("Processes", true)
        this.AddTextBlock("RunBefore", "Run Before Game", true, "Run one or more processes before launching the game. Each line should contain a command to run or a full path to a .exe or shortcut file to launch.`n`nEach process will be run as a scheduled task so that it is not owned by the launcher.", false, 3, ";")
        this.AddTextBlock("CloseBefore", "Close Before Game", true, "Close one or more processes before launching the game. Each line should contain the name of the process to close (usually just the .exe filename).", false, 3, ";")
        this.AddTextBlock("RunAfter", "Run After Game", true, "Run one or more processes after closing the game. Each line should contain a command to run or a full path to a .exe or shortcut file to launch.`n`nEach process will be run as a scheduled task so that it is not owned by the launcher.", false, 3, ";")
        this.AddTextBlock("CloseAfter", "Close After Game", true, "Close one or more processes after closing the game. Each line should contain the name of the process to close (usually just the .exe filename).", false, 3, ";")

        tabs.UseTab("Advanced", true)

        this.AddHeading("Logging Level")
        chosen := this.GetItemIndex(this.logLevels, this.entityObj.LoggingLevel)
        ctl := this.guiObj.AddDDL("vLoggingLevel xs y+m Choose" . chosen . " w" . this.windowSettings["contentWidth"] . " c" . this.themeObj.GetColor("editText"), this.logLevels)
        ctl.OnEvent("Change", "OnLoggingLevelChange")
        this.AddEntityCtl("LogPath", "Log Path", false, "LocationBlock", "", "", "LogPath", "", "Clear", true)
        
        tabs.UseTab()
    }

    AddEntityCtl(fieldName, heading, addPrefix, params*) {
        return this.Add("EntityControl", "", this.entityObj, fieldName, heading, addPrefix, params*)
    }
}
