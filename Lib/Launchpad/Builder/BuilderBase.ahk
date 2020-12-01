class BuilderBase {
    app := ""

    __New(app) {
        InvalidParameterException.CheckTypes("BuilderBase", "app", app, "Launchpad")
        this.app := app
    }

    Build(launcherEntityObj) {
        launcherDir := this.app.Config.DestinationDir
        assetsDir := this.app.Config.AssetsDir

        if (launcherDir == "" or assetsDir == "") {
            this.app.Notifications.Warning(launcherEntityObj.Key . ": Required directories not set. Skipping build.")
            return false
        }

        if (this.app.Config.CreateIndividualDirs) {
            launcherDir .= "\" . launcherEntityObj.Key
        }
        assetsDir .= "\" . launcherEntityObj.Key

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
