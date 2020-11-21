class Builder {
    app := ""
    key := ""
    config := Map()

    __New(app, key, config) {
        this.app := app
        this.key := key
        this.config := config
    }

    Build() {
        launcherDir := this.app.AppConfig.LauncherDir
        assetsDir := this.app.AppConfig.AssetsDir

        if (launcherDir == "" or assetsDir == "") {
            this.app.Toast(this.key . ": Required directories not set. Skipping build.", "Launchpad", 10, 2)
            return false
        }

        if (this.app.AppConfig.IndividualDirs) {
            launcherDir .= "\" . this.key
        }
        assetsDir .= "\" . this.key

        DirCreate(launcherDir)
        DirCreate(assetsDir)

        iconObj := IconFile.new(this.app, this.config, assetsDir, this.key)
        iconResult := iconObj.Build()
        
        shortcutResult := !this.config["requiresShortcutFile"] ; Default to true if shortcut isn't required
        if (this.config["requiresShortcutFile"]) {
            shortcutObj := ShortcutFile.new(this.app, this.config, assetsDir, this.key)
            shortcutResult := shortcutObj.Build()
        }

        ahkResult := false
        exeResult := false

        if (iconResult and shortcutResult) {
            gameAhkObj := GameAhkFile.new(this.app, this.config, assetsDir, this.key)
            ahkResult := gameAhkObj.Build()

            if (ahkResult) {
                gameExeObj := GameExeFile.new(this.app, this.config, launcherDir, this.key)
                exeResult := gameExeObj.Build()
            }
            
        }
        
        return exeResult
    }
}
