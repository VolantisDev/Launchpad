/*
    Properties are dynamically loaded from the container unless overridden.
*/
class PersistentConfig extends ConfigBase {
    _storage := ""
    _overwrite := true
    _persistKey := ""

    __New(configStorage, container, parentKey := "", persistKey := "", autoLoad := true) {
        this._storage := configStorage
        this._persistKey := persistKey
        super.__New(container, parentKey, autoLoad)
    }

    _loadConfigFromStorage() {
        config := this._storage.ReadConfig()
        
        if (!config) {
            config := Map()
        }

        if (this._persistKey) {
            config := Map(this._persistKey, config)
        }

        return config
    }

    _persistConfigToStorage(configMap := "") {
        if (configMap && this._persistKey) {
            configMap := configMap.Has(this._persistKey) ? configMap[this._persistKey] : ""
        }

        return this._storage.WriteConfig(configMap, this._overwrite)
    }
}
