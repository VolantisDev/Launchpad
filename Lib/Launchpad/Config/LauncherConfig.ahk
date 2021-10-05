class LauncherConfig extends PersistentConfig {
    _loadConfigFromStorage() {
        config := super._loadConfigFromStorage()

        for key, configItem in config {
            if (Type(configItem) == "String") {
                config[key] := Map("LauncherType", configItem)
            }
        }

        if (config.Has("Games")) {
            config["games"] := config["Games"]
            config.Delete("Games")
        }

        return config
    }
}
