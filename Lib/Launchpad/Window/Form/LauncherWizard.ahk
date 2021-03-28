class LauncherWizard extends LauncherCreateFormBase {
    installDir := ""
    exe := ""

    __New(app, themeObj, windowKey, owner := "", parent := "") {
        super.__New(app, themeObj, windowKey, "Launcher Wizard", owner, parent)
    }

    GetTextDefinition() {
        return "To start with, simply choose a game key and a launcher type. You can edit many details later if desired."
    }

    Controls() {
        super.Controls()
        this.AddComboBox("Key", "Key", "", this.knownGames, "Select an existing game from the API, or enter a custom game key to create your own. If choosing an existing game, most advanced values can be loaded from the API.")
        this.AddSelect("Platform", "Platform", "", this.knownPlatforms, false, "", "", "Select the platform that this game is run through.", false)
        this.AddLocationBlock("Install Dir", "InstallDir", this.installDir, "", true, "Select the directory the game is installed in")
        this.AddLocationBlock("Game Exe", "Exe", this.exe, "", true, "Select the game's main .exe file")
    }

    OnKeyChange(ctlObj, info) {
        
    }

    OnPlatformChange(ctlObj, info) {
        
    }

    GetLauncherKey() {
        return this.guiObj["Key"].Text
    }

    GetLauncherConfig() {
        platformKey := Trim(this.guiObj["Platform"].Text)
        config := Map("Platform", platformKey, "GameInstallDir", this.installDir, "GameExe", this.exe)
        platform := this.app.Platforms.GetItem(platformKey)
        
        if (platform) {
            config["LauncherType"] := platform.platform.launcherType
            config["GameType"] := platform.platform.gameType
        }

        return config
    }

    OnChangeInstallDir(btn, info) {
        installDir := this.installDir

        if (installDir) {
            installDir := "*" . installDir
        }

        dir := DirSelect(installDir, 2, "Select the game's installation directory")

        if (dir) {
            this.installDir := dir
            this.guiObj["InstallDir"].Text := dir
        }
    }

    OnOpenInstallDir(btn, info) {
        if (this.installDir) {
            Run(this.installDir)
        }
    }

    OnChangeExe(btn, info) {
        selectedFile := FileSelect(1, this.exe, "Select Game Exe", "Executables (*.exe)")

        if (selectedFile) {
            this.exe := selectedFile
            this.guiObj["Exe"].Text := this.exe
        }
    }

    OnOpenExe(btn, info) {
        if (this.exe) {
            Run(this.exe)
        }
    }
}
