class LauncherGame {
    app := ""
    keyVal := ""
    configVal := Map()
    requiredConfigKeysVal := Array("gameType", "gameClass", "launcherType", "launcherClass")

    __New(app, key, config, requiredConfigKeys := "") {
        this.app := app
        this.keyVal := key

        if (requiredConfigKeys != "") {
            this.AddRequiredConfigKeys(requiredConfigKeys)
        }

        if (config != "") {
            this.configVal := config

            if (config.Has("requiredConfigKeys")) {
                this.AddRequiredConfigKeys(config["requiredConfigKeys"])
            }
        }
    }

    AddRequiredConfigKeys(configKeys) {
        for index, requiredKey in configKeys {
            if (!this.ConfigKeyIsRequired(requiredKey)) {
                this.requiredConfigKeysVal.push(requiredKey)
            }
        }
    }

    ConfigKeyIsRequired(configKey) {
        isRequired := false

        for index, requiredKey in this.requiredConfigKeysVal {
            if (configKey == requiredKey) {
                isRequired := true
                break
            }
        }

        return isRequired
    }

    Key[] {
        get {
            return this.keyVal
        }
        set {
            return this.keyVal := value
        }
    }

    DisplayName[] {
        get {
            return this.configVal.Has("displayName") ? this.configVal["displayName"] : this.Key
        }
        set {
            return this.configVal["displayName"] := value
        }
    }

    GameType[] {
        get {
            return this.configVal.Has("gameType") ? this.configVal["gameType"] : "default"
        }
        set {
            return this.configVal["gameType"] := value
        }
    }

    GameClass[] {
        get {
            return this.configVal.Has("gameClass") ? this.configVal["gameClass"] : "ShortcutGame"
        }
        set {
            return this.configVal["gameClass"] := value
        }
    }

    LauncherType[] {
        get {
            return this.configVal.Has("launcherType") ? this.configVal["launcherType"] : "default"
        }
        set {
            return this.configVal["launcherType"] := value
        }
    }

    LauncherClass[] {
        get {
            return this.configVal.Has("launcherClass") ? this.configVal["launcherClass"] : "ThinLauncher"
        }
        set {
            return this.configVal["launcherClass"] := value
        }
    }

    Config[] {
        get {
            return this.configVal
        }
        set {
            return this.configVal := value
        }
    }

    RequiredConfigKeys[] {
        get {
            return this.requiredConfigKeysVal
        }
        set {
            return this.requiredConfigKeysVal := value
        }
    }

    Validate() {
        ; Check for missing values and pop up a configuration screen to fill them out if needed
    }

    Edit(launcherFileObj := "", mode := "config") {
        ; Edit this game, saving it back to the referenced launcher file if supplied
    }
}
