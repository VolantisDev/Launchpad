class ConfigBase {
    configKey := ""
    loaded := false
    allowedKeys := []

    Count {
        get => this.Get().Count
    }

    __Item[name] {
        get => this.Get(name)
        set => this.Set(name, value)
    }

    __New(autoLoad := true) {
        if (this.configKey == "") {
            this.configKey := Type(this)
        }

        if (autoLoad) {
            this.LoadConfig()
        }
    }

    __Enum(numberOfVars) {
        return this.Get().__Enum(numberOfVars)
    }

    IsAllowed(key) {
        keyIsAllowed := true

        if (this.allowedKeys && this.allowedKeys.Length) {
            keyIsAllowed := false

            for index, allowedKey in this.allowedKeys {
                if (key == allowedKey) {
                    keyIsAllowed := true
                    break
                }
            }
        }

        return keyIsAllowed
    }

    Has(key) {
        if (!this.IsAllowed(key)) {
            return false
        }

        return this._has(key)
    }

    _has(key) {
        return this.Get().Has(key)
    }

    Delete(key) {
        if (!this.IsAllowed(key)) {
            throw ConfigException("Not allowed to delete key " . key)
        }

        if (this.Has(key)) {
            this._delete(key)
        }
    }

    _delete(key) {
        this.Get().Delete(key)
    }

    Clone() {
        return super.Clone()
    }

    Get(key := "") {
        if (key) {
            if (!this.IsAllowed(key)) {
                throw ConfigException("Parameter " . key . " is not allowed to be accessed by this config object.")
            }
            
            if (!this.Has(key)) {
                throw ConfigException("Config key " . key . " doesn't exist.")
            }
        }

        return this._get(key)
    }

    _get(key := "") {
        return ""
    }

    Set(key, value) {
        if (!this.IsAllowed(key)) {
            throw ConfigException("The provided key is not valid for this configuration object.")
        }

        this._set(key, value)
    }

    _set(key, value) {
        return ""
    }

    SetValues(values) {
        for key, value in values {
            this.Set(key, value)
        }

        return this
    }

    LoadConfig(reloadConfig := false) {
        if (this.loaded && !reloadConfig) {
            return this
        }

        this._loadConfig(this._loadConfigFromStorage())
        this.loaded := true
        return this
    }

    _loadConfig(loadedValues) {
        this.SetValues(loadedValues)
    }

    _loadConfigFromStorage() {
        return Map()
    }

    SaveConfig() {
        configMap := this.Get()

        this._persistConfigToStorage(configMap)

        return this
    }

    _persistConfigToStorage(configMap := "") {

    }
}
