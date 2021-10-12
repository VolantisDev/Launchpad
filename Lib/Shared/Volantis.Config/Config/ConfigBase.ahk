class ConfigBase {
    container := ""
    parentKey := ""
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

    __New(container, parentKey := "", autoLoad := true) {
        this.container := container
        this.parentKey := parentKey

        if (this.configKey == "") {
            this.configKey := Type(this)
        }

        if (autoLoad) {
            this.LoadConfig()
        }
    }

    __Enum(numberOfVars) {
        return this.container.GetParameter(this.parentKey).__Enum(numberOfVars)
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

        return this.container.HasParameter(this._getContainerKey(key))
    }

    Delete(key) {
        if (!this.IsAllowed(key)) {
            throw ConfigException("Not allowed to delete key " . key)
        }

        if (this.Has(key)) {
            this.container.DeleteParameter(key)
        }
    }

    Clone() {
        return super.Clone()
    }

    _getContainerKey(key) {
        if (this.parentKey) {
            if (key) {
                key := "." . key
            }

            key := this.parentKey . key
        }

        return key
    }

    Get(name := "") {
        if (name) {
            if (!this.IsAllowed(name)) {
                throw ConfigException("Parameter " . name . " is not allowed to be accessed by this config object.")
            }
            
            if (!this.Has(name)) {
                throw ConfigException("Parameter " . this._getContainerKey(name) . " doesn't exist in the service container.")
            }
        }

        return this._getContainerParameter(name)
    }

    _getContainerParameter(key := "") {
        return this.container.GetParameter(this._getContainerKey(key))
    }

    Set(name, value) {
        if (!this.IsAllowed(name)) {
            throw ConfigException("The provided key is not valid for this configuration object.")
        }

        this._setContainerParameter(name, value)
    }

    _setContainerParameter(key, value) {
        this.container.SetParameter(this._getContainerKey(key), value)
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

        config := this._loadConfigFromStorage()

        for key, value in config {
            this._setContainerParameter(key, value)
        }

        this.loaded := true
        return this
    }

    _loadConfigFromStorage() {
        return Map()
    }

    SaveConfig() {
        configMap := this.parentKey ? this._getContainerParameter() : ""

        this._persistConfigToStorage(configMap)

        return this
    }

    _persistConfigToStorage(configMap := "") {

    }
}
