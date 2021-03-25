/**
    This GUI edits a GameLauncher object.

    Modes:
      - "config" - Launcher configuration is being edited
      - "build" - Launcher is being built and requires information
*/

class LauncherEditorSimple extends LauncherEditorBase {
    __New(app, entityObj, mode := "config", windowKey := "", owner := "", parent := "") {
        if (windowKey == "") {
            windowKey := "LauncherEditorSimple"
        }

        super.__New(app, entityObj, "Launcher Editor", mode, windowKey, owner, parent)
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
        
        this.AddSelect("Platform", "Platform", this.entityObj.Platform, this.platforms, false, "", "", "Select the platform that this game is run through.", false)
        
        tabs.UseTab("Launcher", true)

        this.AddEntityTypeSelect("Launcher", "LauncherType", this.entityObj.ManagedLauncher.EntityType, this.launcherTypes, "", "This tells Launchpad how to interact with any launcher your game might require. If your game's launcher isn't listed, or your game doesn't have a launcher, start with `"Default`".", false)
        this.AddCheckBoxBlock("CloseBeforeRun", "Close launcher before run", true, "If selected, the launcher will be closed before attempting to run the game. This can be useful to ensure the process starts under Launchpad's process instead of the existing launcher's process.", true, this.entityObj.ManagedLauncher)
        this.AddCheckBoxBlock("CloseAfterRun", "Close launcher after run", true, "If selected, the launcher will be closed after the game closes. This can be useful to ensure Steam or other applications know you are done playing the game.", true, this.entityObj.ManagedLauncher)

        tabs.UseTab("Game", true)

        this.AddEntityTypeSelect("Game", "GameType", this.entityObj.ManagedLauncher.ManagedGame.EntityType, this.gameTypes, "", "This tells Launchpad how to launch your game. Most games can use 'default', but launchers can support different game types.", false)
        this.AddLocationBlock("Game Install Directory", "InstallDir", "Clear", true, true, true, "Select the installation folder, or use default for auto-detection.", this.entityObj.ManagedLauncher.ManagedGame)
        this.AddLocationBlock("Game Executable", "Exe", "", true, true, true, "The main .exe file, not including any path information.", this.entityObj.ManagedLauncher.ManagedGame)
        this.AddCheckBoxBlock("ReplaceProcess", "Replace process after launching", true, "After the process is detected, immediately kill and re-launch it so that Launchpad is its parent process.", true, this.entityObj.ManagedLauncher.ManagedGame)

        tabs.UseTab()
    }

    OnDefaultCloseBeforeRun(ctlObj, info) {
        this.SetDefaultValue("CloseBeforeRun", !!(ctlObj.Value), true, "", this.entityObj.ManagedLauncher)
    }

    OnDefaultCloseAfterRun(ctlObj, info) {
        this.SetDefaultValue("CloseAfterRun", !!(ctlObj.Value), true, "", this.entityObj.ManagedLauncher)
    }
    
    OnDefaultExe(ctlObj, info) {
        return this.SetDefaultValue("Exe", !!(ctlObj.Value), true, "", this.entityObj.ManagedLauncher.ManagedGame)
    }

    OnDefaultInstallDir(ctlObj, info) {
        return this.SetDefaultLocationValue(ctlObj, "InstallDir", true, this.entityObj.ManagedLauncher.ManagedGame)
    }

    OnDefaultReplaceProcess(ctlObj, info) {
        return this.SetDefaultValue("ReplaceProcess", !!(ctlObj.Value), true, this.entityObj.ManagedLauncher.ManagedGame)
    }

    OnCloseBeforeRunChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.ManagedLauncher.CloseBeforeRun := !!(ctlObj.Value)
    }

    OnCloseAfterRunChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.ManagedLauncher.CloseAfterRun := !!(ctlObj.Value)
    }

    OnExeChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.ManagedLauncher.ManagedGame.Exe := ctlObj.Value
    }

    OnReplaceProcessChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.ManagedLauncher.ManagedGame.ReplaceProcess := !!(ctlObj.Value)
    }

    OnChangeInstallDir(ctlObj, info) {
        existingVal := this.entityObj.ManagedLauncher.ManagedGame.GetConfigValue("InstallDir")

        if existingVal {
            existingVal := "*" . existingVal
        }

        dir := DirSelect(existingVal, 2, this.entityObj.ManagedLauncher.ManagedGame.configPrefix . ": Select the installation directory")

        if (dir) {
            this.entityObj.ManagedLauncher.ManagedGame.SetConfigValue("InstallDir", dir)
            this.guiObj["InstallDir"].Text := dir
        }
    }

    OnOpenInstallDir(ctlObj, info) {
        val := this.entityObj.ManagedLauncher.ManagedGame.GetConfigValue("InstallDir")

        if (val) {
            Run val
        }
    }

    OnClearInstallDir(ctlObj, info) {
        this.entityObj.ManagedLauncher.ManagedGame.SetConfigValue("InstallDir", "")
    }
}
