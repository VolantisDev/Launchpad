class PlatformsConfig extends JsonConfig {
    primaryConfigKey := "Platforms"
    gameDefaults := Map()

    Platforms[] {
        get => (this.config.Has("Platforms") && this.config["Platforms"] != "") ? this.config["Platforms"] : this.config["Platforms"] := Map()
        set => this.config["Platforms"] := value
    }

    LoadConfig() {
        result := super.LoadConfig()

        for key, config in this.Platforms {
            if (Type(config) == "String") {
                this.Platforms[key] := Map("PlatformClass", config)
            }
        }

        return result
    }

    SaveConfig() {
        for key, config in this.Platforms {
            if (Type(config) == "Map" and config.Has("PlatformClass") and config.Count == 1) {
                this.Platforms[key] := config["PlatformClass"]
            }
        }

        return super.SaveConfig()
    }
}
