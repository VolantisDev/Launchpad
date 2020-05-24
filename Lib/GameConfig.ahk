class GameConfig {
    app := {}
    launcherDir := ""
    key := ""
    launcherTypeValue := "GameLauncher"
    gameTypeValue := "Game"
    gameIdValue := ""
    gameShortcutValue := ""
    gameIconValue := ""
    workingDirValue := ""
    useClassValue := ""
    requiresWorkingDirValue := ""

    LauncherType[] {
        get {
            return this.launcherTypeValue
        }
        set {
            return this.launcherTypeValue := value
        }
    }

    GameType[] {
        get {
            return this.gameTypeValue
        }
        set {
            return this.gameTypeValue := value
        }
    }

    GameId[] {
        get {
            return this.gameIdValue
        }
        set {
            return this.gameIdValue := value
        }
    }

    GameShortcut[] {
        get {
            return this.gameShortcutValue
        }
        set {
            return this.gameShortcutValue := value
        }
    }

    GameIcon[] {
        get {
            return this.gameIconValue
        }
        set {
            return this.gameIconValue := value
        }
    }

    WorkingDir[] {
        get {
            return this.workingDirValue
        }
        set {
            return this.workingDirValue := value
        }
    }

    UseClass[] {
        get {
            return this.useClassValue
        }
        set {
            return this.useClassValue := value
        }
    }

    RequiresWorkingDir[] {
        get {
            return this.requiresWorkingDirValue
        }
        set {
            return this.requiresWorkingDirValue := value
        }
    }

    __New(app, key, config) {
        this.app := app
        this.key := key
        this.launcherDir := this.app.AppConfig.LauncherDir . "\" . key

        this.launcherTypeValue := config.hasKey("launcherType") ? config.launcherType : "GameLauncher"
        this.gameTypeValue := config.hasKey("gameType") ? config.gameType : "Game"
        this.gameIdValue := config.hasKey("gameId") ? config.gameId : key

        this.requiresWorkingDirValue := config.hasKey("requiresWorkingDir") ? config.useClass : false
        ; if (!config.hasKey("requiresWorkingDir") and this.launcherTypeValue == "BlizzardLauncher") {
        ;     this.requiresWorkingDirValue := true
        ; }

        this.workingDirValue := config.hasKey("workingDir") ? config.workingDir : this.PrepareWorkingDir()
        this.useClassValue := config.hasKey("useClass") ? config.useClass : false
        this.gameShortcutValue := config.hasKey("gameShortcut") ? config.gameShortcut : ""
        this.gameIconValue := config.hasKey("gameIcon") ? config.gameIcon : ""
    }

    PrepareGameFiles() {
        FileCreateDir, % this.launcherDir
        this.gameIconValue := this.PrepareGameIcon()
        this.gameShortcutValue := this.PrepareGameShortcut()
        this.PrepareGameAhkFile()
        return true
    }

    CopyTemplateFiles() {
        gameTemplateObj := new GameTemplate(this.app.AppConfig.AppDir, this.launcherDir, this.key, this.gameTypeValue)
        gameTemplateObj.CopyTemplateFiles()
    }

    PrepareGameAhkFile() {
        ahkFileObj := new GameAhkFile(this.app.AppConfig.AppDir, this.launcherDir, this.key, this)
        return ahkFileObj.AhkPath
    }

    PrepareGameIcon() {
        iconObj := new GameIcon(this.app.AppConfig.AppDir, this.launcherDir, this.key, this.gameIconValue)
        return iconObj.IconPath
    }

    PrepareGameShortcut() {
        if (this.gameTypeValue == "BnetlauncherGame" or this.gameTypeValue == "MicrosoftStoreGame") {
            return this.gameShortcutValue
        }

        shortcutObj := new GameShortcut(this.launcherDir, this.key, this.gameShortcutValue)
        return shortcutObj.ShortcutPath
    }

    PrepareWorkingDir() {
        if (!this.workingDirValue and this.requiresWorkingDirValue) {
            FileSelectFolder, folder,,, % this.key . ": Select the game's working directory"
            this.workingDirValue := folder
        }

        return this.workingDirValue
    }
}
