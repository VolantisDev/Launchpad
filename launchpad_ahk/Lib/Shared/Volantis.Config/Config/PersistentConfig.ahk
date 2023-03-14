/*
    Properties are dynamically loaded from the container unless overridden.
*/
class PersistentConfig extends ContainerConfigBase {
    _storage := ""
    _overwrite := true

    __New(configStorage, container, parentKey := "", autoLoad := true) {
        this._storage := configStorage
        super.__New(container, parentKey, autoLoad)
    }

    _loadConfigFromStorage() {
        config := this._storage.ReadConfig()
        
        if (!config) {
            config := Map()
        }

        return config
    }

    _persistConfigToStorage(configMap := "") {
        return this._storage.WriteConfig(configMap, this._overwrite)
    }
}
