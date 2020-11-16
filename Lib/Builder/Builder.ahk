class Builder {
    app := {}
    key := {}
    config := {}

    __New(app, key, config) {
        this.app := app
        this.key := key
        this.config := config
    }

    Build() {
        launcherDir := this.app.AppConfig.LauncherDir

        if (this.app.AppConfig.IndividualDirs) {
            launcherDir .= "\" . this.key
        }

        assetsDir := this.app.AppConfig.AssetsDir . "\" . this.key

        FileCreateDir, %launcherDir%
        FileCreateDir, %assetsDir%

        new IconFile(this.app, this.config, assetsDir, this.key)
        
        if (this.config.requiresShortcutFile) {
            new ShortcutFile(this.app, this.config, assetsDir, this.key)
        }

        new GameAhkFile(this.app, this.config, launcherDir, this.key)
        new GameExeFile(this.app, this.config, launcherDir, this.key)

        return true
    }
}
