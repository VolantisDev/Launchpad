class Builder {
    app := ""

    __New(app) {
        this.app := app
    }

    Build(key, config) {
        launcherDir := this.app.AppConfig.LauncherDir
        assetsDir := this.app.AppConfig.AssetsDir

        if (launcherDir == "" or assetsDir == "") {
            this.app.Notifications.Warning(key . ": Required directories not set. Skipping build.")
            return false
        }

        if (this.app.AppConfig.IndividualDirs) {
            launcherDir .= "\" . key
        }
        assetsDir .= "\" . key

        DirCreate(launcherDir)
        DirCreate(assetsDir)

        iconObj := IconFile.new(this.app, config, assetsDir, key)
        iconResult := iconObj.Build()
        
        shortcutResult := !config["requiresShortcutFile"] ; Default to true if shortcut isn't required
        if (config["requiresShortcutFile"]) {
            shortcutObj := ShortcutFile.new(this.app, config, assetsDir, key)
            shortcutResult := shortcutObj.Build()
        }

        ahkResult := false
        exeResult := false

        if (iconResult and shortcutResult) {
            gameAhkObj := GameAhkFile.new(this.app, config, assetsDir, key)
            ahkResult := gameAhkObj.Build()

            if (ahkResult) {
                gameExeObj := GameExeFile.new(this.app, config, launcherDir, key)
                exeResult := gameExeObj.Build()
            }
            
        }
        
        return exeResult
    }
}
