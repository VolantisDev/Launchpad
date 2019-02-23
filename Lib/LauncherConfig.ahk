class LauncherConfig {
    filePath := ""
    defaultsFilePath := ""
    config := {}
    defaults := {}

    Games[] {
        get {
            if (this.config.Games) {
                return this.config.Games
            } else {
                return {}
            }
        }
        set {
            return this.config.Games := value
        }
    }

    __New(filePath, defaultsFilePath := "", autoLoad := true) {
        this.filePath := filePath
        this.defaultsFilePath := defaultsFilePath

        if (autoLoad and this.filePath) {
            this.LoadConfig()
        }
    }

    LoadConfig() {
        if (!this.filePath) {
            MsgBox, Launchers file path not provided.
            return this
        }

        FileRead, jsonString, % this.filePath

        if (jsonString) {
            this.config := JSON.Load(jsonString)
            this.PopulateFromDefaults()
        } else {
            this.config := {}
        }

        return this
    }

    LoadDefaults() {
        if (this.defaultsFilePath) {
            FileRead, jsonString, % this.defaultsFilePath

            if (jsonString) {
                this.defaults := JSON.Load(jsonString)
            } else {
                this.defaults := {}
            }
        }
    }

    PopulateFromDefaults() {
        if (!this.defaults._NewEnum()[k, v]) {
            this.LoadDefaults()
        }

        for key, config in this.config.Games
        {
            if (this.defaults.Games.hasKey(key)) {
                newConfig := this.defaults.Games[key]
                for gameKey, gameValue in config
                {
                    newConfig[gameKey] := gameValue
                }
                this.config.Games[key] := newConfig
            }
        }
    }

    SaveConfig() {
        if (!filePath) {
            this.AskForPath()
        }

        if (!filePath) {
            MsgBox, Launchers file path not provided.
            return this
        }

        FileDelete, % this.filePath
        jsonString := JSON.Dump(this.config, "", 4)
        FileAppend, %jsonString%, % this.filePath

        return this
    }
}
