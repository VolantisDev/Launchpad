class PlatformsConfig extends PersistentConfig {
    _loadConfigFromStorage() {
        config := super._loadConfigFromStorage()

        if (config) {
            for key, configItem in config {
                if (Type(configItem) == "String") {
                    config[key] := Map("PlatformClass", configItem)
                }
            }
        }

        return config
    }
}
