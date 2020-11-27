class BuilderBase {
    app := ""

    __New(app) {
        this.app := app
    }

    Build(launcherGameObj) {
        launcherDir := this.app.Config.DestinationDir
        assetsDir := this.app.Config.AssetsDir

        if (launcherDir == "" or assetsDir == "") {
            this.app.Notifications.Warning(launcherGameObj.Key . ": Required directories not set. Skipping build.")
            return false
        }

        if (this.app.Config.CreateIndividualDirs) {
            launcherDir .= "\" . launcherGameObj.Key
        }
        assetsDir .= "\" . launcherGameObj.Key

        DirCreate(launcherDir)
        DirCreate(assetsDir)

        iconObj := IconFile.new(this.app, launcherGameObj, assetsDir, launcherGameObj.Key)
        iconResult := iconObj.Build()
        
        shortcutResult := !this.NeedsShortcutFile(launcherGameObj) ; Default to true if shortcut isn't required
        if (this.NeedsShortcutFile(launcherGameObj)) {
            shortcutObj := ShortcutFile.new(this.app, launcherGameObj, assetsDir, launcherGameObj.Key)
            shortcutResult := shortcutObj.Build()
        }

        return this.BuildAction(launcherGameObj, launcherDir, assetsDir)
    }

    NeedsShortcutFile(launcherGameObj) {
        return (launcherGameObj.SupportsShortcut && launcherGameObj.RunCmd == "")
    }

    BuildAction(launcherGameObj, launcherDir, assetsDir) {
        ; This must be overridden for all subclasses
    }

    Clean(launcherGameObj) {
        return false
    }
}
