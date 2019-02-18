class LauncherConfig {
    filePath := ""
    config := {}

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

    __New(filePath, autoLoad := true) {
        this.filePath := filePath

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
        } else {
            this.config := {}
        }

        return this
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
