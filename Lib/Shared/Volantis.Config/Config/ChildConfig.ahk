class ChildConfig extends ConfigBase {
    parentConfig := ""
    childKey := ""
    autoCreate := ""

    __New(parentConfig, childKey, autoLoad := true, autoCreate := true) {
        this.parentConfig := parentConfig
        this.childKey := childKey
        this.autoCreate := autoCreate

        super.__New(autoLoad)
    }

    IsAllowed(key) {
        allowed := super.IsAllowed(key)

        if (allowed) {
            allowed := this.parentConfig.IsAllowed(this._getFullKey(key))
        }

        return allowed
    }

    _getFullKey(key) {
        absKey := this.childKey

        if (absKey) {
            absKey .= "."
        }

        return absKey . key 
    }

    _has(key) {
        return this.parentConfig.Has(this._getFullKey(key))
    }

    _delete(key) {
        return this.parentConfig.Delete(this._getFullKey(key))
    }

    _get(key) {
        return this.parentConfig.Get(this._getFullKey(key))
    }

    _set(key, value) {
        return this.parentConfig.Set(this._getFullKey(key), value)
    }

    _loadConfigFromStorage() {
        this.parentConfig.LoadConfig(false)

        if (!this.parentConfig.Has(this.childKey) && this.autoCreate) {
            this.parentConfig.Set(this.childKey, Map())
        }

        return Map() ; Values don't need to be set
    }

    _persistConfigToStorage(configMap := "") {
        return this.parentConfig.SaveConfig()
    }
}
