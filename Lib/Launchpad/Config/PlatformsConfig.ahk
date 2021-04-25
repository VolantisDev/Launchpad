class PlatformsConfig extends JsonConfig {
    primaryConfigKey := "Platforms"
    gameDefaults := Map()
    configKey := "PlatformsConfig"

    Platforms {
        get => this.config["Platforms"]
        set => this.config["Platforms"] := value
    }

    LoadConfig() {
        result := super.LoadConfig()

        if (!this.config.Has("Platforms")) {
            this.config["Platforms"] := Map()
        }

        for key, config in this.Platforms {
            if (Type(config) == "String") {
                this.Platforms[key] := Map("PlatformClass", config)
            }
        }

        return result
    }

    SaveConfig() {
        return super.SaveConfig()
    }
}
