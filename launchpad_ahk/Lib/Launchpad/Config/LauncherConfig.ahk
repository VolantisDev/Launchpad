class LauncherConfig extends PersistentConfig {
    _loadConfigFromStorage() {
        config := super._loadConfigFromStorage()

        for key, configItem in config {
            if (Type(configItem) == "String") {
                config[key] := Map("LauncherType", configItem)
            }
        }

        return config
    }
}
