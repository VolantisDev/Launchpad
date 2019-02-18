class LauncherGen {
    appConfigValue := {}
    appName := ""
    appDir := ""
    launcherDir := ""
    config := {}
    updateExisting := false

    AppConfig[] {
        get {
            return this.appConfigValue
        }
        set {
            return this.appConfigValue := value
        }
    }

    __New(appName, appDir, askUpdateExisting := true) {
        this.appConfigValue := new AppConfig(appName, appDir)
        this.config := new LauncherConfig(this.appConfigValue.LauncherFile)

        if (askUpdateExisting) {
            this.AskUpdateExisting()
        }
    }

    AskUpdateExisting() {
        MsgBox, 4,, Would you also like to update existing launchers? (choosing No will only create new launchers)
        IfMsgBox Yes
            this.updateExisting := true
        else
            this.updateExisting := false
    }

    UpdateVendorFiles() {
        autohotkey := new AutoHotKey(this.AppConfig.AppDir)
        if (autohotkey.NeedsUpdate()) {
            autohotkey.Download()
        }

        bnetlauncher := new Bnetlauncher(this.AppConfig.AppDir)
        if (bnetlauncher.NeedsUpdate()) {
            bnetlauncher.Download()
        }

        iconsext := new IconsExt(this.AppConfig.AppDir)
        if (iconsext.NeedsUpdate()) {
            iconsext.Download()
        }
    }

    GenerateLaunchers() {
        generated := 0
        built := 0

        For key, config in this.config.Games {
            success := false
            if (this.updateExisting or !this.LauncherExists(key, config)) {
                success := this.GenerateLauncherFiles(key, config)

                if (success) {
                    generated++
                }
            }

            if (this.updateExisting or success) {
                success := this.BuildLauncher(key, config)

                if (success) {
                    built++
                }
            }
        }

        MsgBox, Generated launcher files for %generated% games and built %built% launchers.
    }

    LauncherExists(key, config) {
        if (!FileExist(this.appConfigValue.LauncherDir)) {
            return false
        }

        gameDir := this.appConfigValue.LauncherDir . "\" . key

        if (!FileExist(gameDir)) {
            return false
        }

        launcherFile := gameDir . "\" . key . ".ahk"
        return FileExist(launcherFile)
    }

    LauncherIsBuilt(key, config) {
        if (!this.LauncherExists(key, config)) {
            return false
        }

        launcherExe := this.appConfigValue.LauncherDir . "\" . key . "\" . key . ".exe"
        return FileExist(launcherExe)
    }

    GenerateLauncherFiles(key, config) {
        gameConfigObj := new GameConfig(this, key, config)
        return gameConfigObj.PrepareGameFiles()
    }

    BuildLauncher(key, config) {
        exeBuilderObj := new ExeBuilder(this)
        return exeBuilderObj.BuildExe(key)
    }
}
