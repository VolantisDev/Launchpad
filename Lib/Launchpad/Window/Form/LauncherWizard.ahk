class LauncherWizard extends LauncherCreateFormBase {
    installDir := ""
    exe := ""
    defaultPlatform := ""

    __New(app, themeObj, windowKey, owner := "", parent := "") {
        super.__New(app, themeObj, windowKey, "Launcher Wizard", owner, parent)
    }

    GetTextDefinition() {
        return "To start with, simply choose a game key and a launcher type. You can edit many details later if desired."
    }

    Controls() {
        super.Controls()
        this.AddComboBox("Key", "Key", "", this.knownGames, "Select an existing game from the API, or enter a custom game key to create your own. If choosing an existing game, most advanced values can be loaded from the API.")
        this.Add("SelectControl", "", "Platform", defaultPlatform, this.knownPlatforms, "", "Select the platform that this game is run through.")
        this.Add("LocationBlock", "", "Install Dir", this.installDir, "InstallDir", "", true, "Select the directory the game is installed in")
        this.Add("LocationBlock", "", "Game Exe", this.exe, "Exe", "", true, "Select the game's main .exe file")
    }

    OnKeyChange(ctlObj, info) {
        
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

    OnInstallDirMenuClick(btn) {
        if (btn == "ChangeInstallDir") {
            installDir := this.installDir

            if (installDir) {
                installDir := "*" . installDir
            }

            dir := DirSelect(installDir, 2, "Select the game's installation directory")

            if (dir) {
                this.installDir := dir
                this.guiObj["InstallDir"].Text := dir
            }
        } else if (btn == "OpenInstallDir") {
            if (this.installDir) {
                Run(this.installDir)
            }
        } else if (btn == "ClearInstallDir") {
            this.installDir := ""
            this.guiObj["InstallDir"].Text := ""
        }
    }

    OnExeMenuClick(btn) {
        if (btn == "ChangeExe") {
            selectedFile := FileSelect(1, this.exe, "Select Game Exe", "Executables (*.exe)")

            if (selectedFile) {
                this.exe := selectedFile
                this.guiObj["Exe"].Text := this.exe
            }
        } else if (btn == "OpenExe") {
            if (this.exe) {
                Run(this.exe)
            }
        } else if (btn == "ClearExe") {
            this.exe := ""
            this.guiObj["Exe"].Text := ""
        }
    }
}
