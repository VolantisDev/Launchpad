class LauncherGame {
    keyVal := ""
    displayNameVal := ""
    gameTypeVal := ""
    launcherTypeVal := ""
    configVal := Map()
    requiredConfigKeysVal := Map()

    __New(key, config := "") {
        this.keyVal := key

        if (config != "") {
            this.configVal := config
        }
    }

    Key[] {
        get {
            return this.keyValue
        }
        set {
            return this.keyValue := value
        }
    }

    DisplayName[] {
        get {
            return this.displayNameValue
        }
        set {
            return this.displayNameValue := value
        }
    }

    GameType[] {
        get {
            return this.gameTypeVal
        }
        set {
            return this.gameTypeVal := value
        }
    }

    LauncherType[] {
        get {
            return this.launcherTypeVal
        }
        set {
            return this.launcherTypeVal := value
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

    Edit(launcherFileObj := "") {
        ; Edit this game, saving it back to the referenced launcher file if supplied
    }

    Build(isInBatch := false) {
        ; Show a progress window if not in a batch process already
    }
}
