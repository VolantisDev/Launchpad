class BuilderBase {
    app := ""

    __New(app) {
        this.app := app
    }

    Build(launcherGameObj) {
        launcherDir := this.app.Config.LauncherDir
        assetsDir := this.app.Config.AssetsDir

        if (launcherDir == "" or assetsDir == "") {
            this.app.Notifications.Warning(launcherGameObj.Key . ": Required directories not set. Skipping build.")
            return false
        }

        if (this.app.Config.IndividualDirs) {
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

        return this.BuildAction(launcherGameObj, launcherDir, assetsDir)
    }

    BuildAction(launcherGameObj, launcherDir, assetsDir) {
        ; This must be overridden for all subclasses
    }
}
