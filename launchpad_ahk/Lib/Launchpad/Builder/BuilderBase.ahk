class BuilderBase {
    app := ""
    notifierObj := ""

    __New(app, notifierObj) {
        InvalidParameterException.CheckTypes("BuilderBase", "app", app, "AppBase")
        this.app := app
        this.notifierObj := notifierObj
    }

    Build(launcherEntityObj) {
        launcherDir := launcherEntityObj["DestinationDir"]
        assetsDir := launcherEntityObj["AssetsDir"]

        if (launcherDir == "" or assetsDir == "") {
            this.notifierObj.Warning(launcherEntityObj.Id . ": Required directories not set. Skipping build.")
            return false
        }

        DirCreate(launcherDir)
        DirCreate(assetsDir)

        iconObj := IconFile(launcherEntityObj)
        iconResult := iconObj.Build()
        
        if (this.NeedsShortcutFile(launcherEntityObj)) {
            shortcutObj := ShortcutFile(launcherEntityObj)
            shortcutResult := shortcutObj.Build()
        }

        return this.BuildAction(launcherEntityObj, launcherDir, assetsDir)
    }

    NeedsShortcutFile(launcherEntityObj) {
        return (launcherEntityObj["GameProcess"]["UsesShortcut"])
    }

    BuildAction(launcherEntityObj, launcherDir, assetsDir) {
        ; This must be overridden for all subclasses
    }

    Clean(launcherEntityObj) {
        return false
    }
}
