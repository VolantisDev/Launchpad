class BuilderBase {
    app := ""

    __New(app) {
        InvalidParameterException.CheckTypes("BuilderBase", "app", app, "AppBase")
        this.app := app
    }

    Build(launcherEntityObj) {
        launcherDir := launcherEntityObj.DestinationDir
        assetsDir := launcherEntityObj.AssetsDir

        if (launcherDir == "" or assetsDir == "") {
            this.app.Service("NotificationService").Warning(launcherEntityObj.Key . ": Required directories not set. Skipping build.")
            return false
        }

        DirCreate(launcherDir)
        DirCreate(assetsDir)

        iconObj := IconFile.new(launcherEntityObj)
        iconResult := iconObj.Build()
        
        if (this.NeedsShortcutFile(launcherEntityObj)) {
            shortcutObj := ShortcutFile.new(launcherEntityObj)
            shortcutResult := shortcutObj.Build()
        }

        return this.BuildAction(launcherEntityObj, launcherDir, assetsDir)
    }

    NeedsShortcutFile(launcherEntityObj) {
        return (launcherEntityObj.ManagedLauncher.ManagedGame.UsesShortcut)
    }

    BuildAction(launcherEntityObj, launcherDir, assetsDir) {
        ; This must be overridden for all subclasses
    }

    Clean(launcherEntityObj) {
        return false
    }
}
