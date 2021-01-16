class PlatformsConfig extends JsonConfig {
    primaryConfigKey := "Platforms"
    gameDefaults := Map()

    Platforms[] {
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
        for key, config in this.Platforms {
            if (Type(config) == "Map" && config.Has("PlatformClass") && config.Count == 1) {
                this.Platforms[key] := config["PlatformClass"]
            }
        }

        return super.SaveConfig()
    }
}
