class Builder {
    app := ""

    __New(app) {
        this.app := app
    }

    Build(launcherGameObj) {
        launcherDir := this.app.AppConfig.LauncherDir
        assetsDir := this.app.AppConfig.AssetsDir

        if (launcherDir == "" or assetsDir == "") {
            this.app.Notifications.Warning(launcherGameObj.Key . ": Required directories not set. Skipping build.")
            return false
        }

        if (this.app.AppConfig.IndividualDirs) {
            launcherDir .= "\" . launcherGameObj.Key
        }
        assetsDir .= "\" . launcherGameObj.Key

        DirCreate(launcherDir)
        DirCreate(assetsDir)

        iconObj := IconFile.new(this.app, launcherGameObj, assetsDir, launcherGameObj.Key)
        iconResult := iconObj.Build()
        
        shortcutResult := !launcherGameObj.Config["requiresShortcutFile"] ; Default to true if shortcut isn't required
        if (launcherGameObj.Config["requiresShortcutFile"]) {
            shortcutObj := ShortcutFile.new(this.app, launcherGameObj, assetsDir, launcherGameObj.Key)
            shortcutResult := shortcutObj.Build()
        }

        ahkResult := false
        exeResult := false

        if (iconResult and shortcutResult) {
            gameAhkObj := GameAhkFile.new(this.app, launcherGameObj, assetsDir, launcherGameObj.Key)
            ahkResult := gameAhkObj.Build()

            if (ahkResult) {
                gameExeObj := GameExeFile.new(this.app, launcherGameObj, launcherDir, launcherGameObj.Key)
                exeResult := gameExeObj.Build()
            }
            
        }
        
        return exeResult
    }
}
