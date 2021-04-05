/**
    This GUI edits a GameLauncher object.

    Modes:
      - "config" - Launcher configuration is being edited
      - "build" - Launcher is being built and requires information
*/

class LauncherEditorSimple extends LauncherEditorBase {
    __New(app, themeObj, windowKey, entityObj, mode := "config", owner := "", parent := "") {
        super.__New(app, themeObj, windowKey, entityObj, "Launcher Editor", mode, owner, parent)
    }

    GetButtonsDefinition() {
        buttonsDef := super.GetButtonsDefinition()
        buttonsDef .= "|&Advanced"
        return buttonsDef
    }

    Controls() {
        super.Controls()
        tabs := this.guiObj.Add("Tab3", " x" . this.margin . " w" . this.windowSettings["contentWidth"] . " +0x100", ["General", "Launcher", "Game"])

        tabs.UseTab("General", true)
        this.AddComboBox("Key", "Key", this.entityObj.Key, this.knownGames, "Select an existing game from the API, or enter a custom game key to create your own. Use caution when changing this value, as it will change which data is requested from the API.")
        this.AddEntityCtl("Platform", "Platform", false, "SelectControl", this.platforms, "", "Select the platform that this game is run through.")
        
        tabs.UseTab("Launcher", true)
        ctl := this.Add("EntityControl", "", "Launcher", this.entityObj.ManagedLauncher, "LauncherType", false, "SelectControl", this.launcherTypes, "", "This tells " . this.app.appName . " how to interact with any launcher your game might require. If your game's launcher isn't listed, or your game doesn't have a launcher, start with `"Default`"")
        ctl.refreshDataOnChange := true
        
        ctl := this.Add("EntityControl", "", "", this.entityObj.ManagedLauncher, "LauncherCloseBeforeRun", true, "BasicControl", "CheckBox", "Close launcher before run")
        ctl.ctl.ToolTip := "If selected, the launcher will be closed before attempting to run the game. This can be useful to ensure the process starts under " . this.app.appName . "'s process instead of the existing launcher's process."

        ctl := this.Add("EntityControl", "", "", this.entityObj.ManagedLauncher, "LauncherCloseAfterRun", true, "BasicControl", "CheckBox", "Close launcher after run")
        ctl.ctl.ToolTip := "If selected, the launcher will be closed after the game closes. This can be useful to ensure Steam or other applications know you are done playing the game."

        tabs.UseTab("Game", true)
        ctl := this.Add("EntityControl", "", "Game", this.entityObj.ManagedLauncher.ManagedGame, "GameType", false, "SelectControl", this.gameTypes, "", "This tells " . this.app.appName . " how to launch your game. Most games can use 'default', but launchers can support different game types.")
        ctl.refreshDataOnChange := true
        this.Add("EntityControl", "", "Game Install Directory", this.entityObj.ManagedLauncher.ManagedGame, "GameInstallDir", true, "LocationBlock", "GameInstallDir", "Clear", true, "Select the installation folder, or use default for auto-detection.")
        this.Add("EntityControl", "", "Game Executable", this.entityObj.ManagedLauncher.ManagedGame, "GameExe", true, "LocationBlock", "GameExe", "Clear", true, "The main .exe file, not including any path information.")
        
        ctl := this.Add("EntityControl", "", "", this.entityObj.ManagedLauncher.ManagedGame, "GameReplaceProcess", true, "BasicControl", "CheckBox", "Replace process after launching")
        ctl.ctl.ToolTip := "After the process is detected, immediately kill and re-launch it so that " . this.app.appName . " is its parent process."

        tabs.UseTab()
    }

    OnGameExeMenuClick(btn) {
        if (btn == "ChangeGameExe") {
            existingVal := this.entityObj.ManagedLauncher.ManagedGame.GetConfigValue("Exe")

            if (!existingVal) {
                existingVal := this.entityObj.ManagedLauncher.ManagedGame.GetConfigValue("InstallDir")
            }

            file := FileSelect(1, existingVal, "Select Game Exe", "Executables (*.exe)")

            if (file) {
                this.entityObj.ManagedLauncher.ManagedGame.SetConfigValue("Exe", file)
                this.guiObj["Exe"].Text := file
            }
        } else if (btn == "OpenGameExe") {
            val := this.entityObj.ManagedLauncher.ManagedGame.GetConfigValue("Exe")

            if (val) {
                Run val
            }
        } else if (btn == "ClearGameExe") {
            this.entityObj.ManagedLauncher.ManagedGame.SetConfigValue("Exe", "")
            this.guiObj["Exe"].Text := ""
        }
    }

    OnGameInstallDirMenuClick(btn) {
        if (btn == "ChangeGameInstallDir") {
            existingVal := this.entityObj.ManagedLauncher.ManagedGame.GetConfigValue("InstallDir")

            if existingVal {
                existingVal := "*" . existingVal
            }

            dir := DirSelect(existingVal, 2, this.entityObj.ManagedLauncher.ManagedGame.configPrefix . ": Select the installation directory")

            if (dir) {
                this.entityObj.ManagedLauncher.ManagedGame.SetConfigValue("InstallDir", dir)
                this.guiObj["InstallDir"].Text := dir
            }
        } else if (btn == "OpenGameInstallDir") {
            val := this.entityObj.ManagedLauncher.ManagedGame.GetConfigValue("InstallDir")

            if (val) {
                Run val
            }
        } else if (btn == "ClearGameInstallDir") {
            this.entityObj.ManagedLauncher.ManagedGame.SetConfigValue("InstallDir", "")
            this.guiObj["InstallDir"].Text := ""
        }
    }
}
