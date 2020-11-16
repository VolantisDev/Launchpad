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
        gameConfigObj := new this.config.launcherClass (this.app, this.key, this.config)
        launcherDir := gameConfig.launcherDir

        FileCreateDir, %launcherDir%

        new IconFile(this.app, gameConfigObj, launcherDir, this.key, "", true, gameConfigObj.GameIcon)
        
        if (gameConfigObj.RequiresShortcutFile) {
            new ShortcutFile(this.app, gameConfigObj, launcherDir, this.key, "", true, gameConfigObj.Shortcut)
        }

        new GameAhkFile(this.app, gameConfigObj, launcherDir, this.key)
        new GameExeFile(this.app, gameConfigObj, launcherDir, this.key)
    }
}
