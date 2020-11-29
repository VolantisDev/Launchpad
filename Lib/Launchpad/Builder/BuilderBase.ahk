class BuilderBase {
    app := ""

    __New(app) {
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

        iconObj := IconFile.new(this.app, launcherEntityObj, assetsDir, launcherEntityObj.Key)
        iconResult := iconObj.Build()
        
        shortcutResult := !this.NeedsShortcutFile(launcherEntityObj) ; Default to true if shortcut isn't required
        if (this.NeedsShortcutFile(launcherEntityObj)) {
            shortcutObj := ShortcutFile.new(this.app, launcherEntityObj, assetsDir, launcherEntityObj.Key)
            shortcutResult := shortcutObj.Build()
        }

        return this.BuildAction(launcherEntityObj, launcherDir, assetsDir)
    }

    NeedsShortcutFile(launcherEntityObj) {
        return (launcherEntityObj.ManagedGame.UsesShortcut && launcherEntityObj.ManagedGame.RunCmd == "")
    }

    BuildAction(launcherEntityObj, launcherDir, assetsDir) {
        ; This must be overridden for all subclasses
    }

    Clean(launcherEntityObj) {
        return false
    }
}
