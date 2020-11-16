; @todo Decide if I still need this
class LauncherGame {
    app := {}
    config := {}
    launcherDir := ""
    key := ""
    launcherConfig := {}
    launcherClass := ""
    gameTypeConfig := {}
    gameClass := ""

    LauncherType[] {
        get {
            return this.config.launcherType
        }
        set {
            return this.config.launcherType := value
        }
    }

    GameType[] {
        get {
            return this.config.gameType
        }
        set {
            return this.config.gameType := value
        }
    }

    GameId[] {
        get {
            return this.config.gameId
        }
        set {
            return this.config.gameId := value
        }
    }

    Shortcut[] {
        get {
            return this.config.shortcut
        }
        set {
            return this.config.shortcut := value
        }
    }

    GameIcon[] {
        get {
            return this.config.gameIcon
        }
        set {
            return this.config.gameIcon := value
        }
    }

    WorkingDir[] {
        get {
            return this.config.workingDir
        }
        set {
            return this.config.workingDir := value
        }
    }

    UseClass[] {
        get {
            return this.config.hasKey("useClass") ? this.config.useClass : false
        }
        set {
            return this.config.useClass := value
        }
    }

    RequiresWorkingDir[] {
        get {
            return this.config.hasKey("requiresWorkingDir") ? this.config.requiresWorkingDir : false
        }
        set {
            return this.config.requiresWorkingDir := value
        }
    }

    RequiresShortcutFile[] {
        get {
            return this.config.hasKey("requiresShortcutFile") ? this.config.requiresShortcutFile : true
        }
        set {
            return this.config.requiresShortcutFile := value
        }
    }

    __New(app, key, config) {
        this.app := app
        this.key := key
        this.config := this.MergeDefaults(key, config)
        this.launcherDir := this.app.AppConfig.LauncherDir . "\" . key

        launcherItem := new LauncherTypeItem(app.launcherDb, this.config.launcherType)
        if (launcherItem.Exists()) {
            this.launcherConfig := launcherItem.Read()
            this.launcherClass := this.launcherConfig.class
        }

        gameItemData := new GameTypeItem(app.launcherDb, this.config.gameType)
        if (gameItemData.Exists()) {
            this.gameTypeConfig := gameItemData.Read()
            this.gameClass := this.gameTypeConfig.class
        }

        if (this.WorkingDir == "" && this.RequiresWorkingDir) {
            this.PrepareWorkingDir()
        }
    }

    MergeDefaults(key, config) {
        newConfig := {}
        newConfig.gameId := key
        newConfig.launcherType := "default"
        newConfig.gameType := "default"
        newConfig.useClass := false
        newConfig.requiresShortcutFile := true
        newConfig.useClass := false
        newConfig.shortcut := "",
        newCOnfig.gameIcon := ""

        for configKey, configValue in config {
            newConfig[configKey] := configValue
        }

        return newConfig
    }

    PrepareWorkingDir() {
        if (this.WorkingDir == "" and this.RequiresWorkingDir) {
            FileSelectFolder, folder,,, % this.key . ": Select the game's working directory"
            this.WorkingDir := folder
        }

        return this.WorkingDir
    }
}
