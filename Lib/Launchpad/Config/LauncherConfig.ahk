class LauncherConfig extends JsonConfig {
    primaryConfigKey := "Games"
    gameDefaults := Map()
    configKey := "LaunchersConfig"

    Games[] {
        get => this.config["Games"]
        set => this.config["Games"] := value
    }

    LoadConfig() {
        result := super.LoadConfig()

        if (!this.config.Has("Games")) {
            this.config["Games"] := Map()
        }

        for key, config in this.Games {
            if (Type(config) == "String") {
                this.Games[key] := Map("LauncherType", config)
            }
        }

        return result
    }

    SaveConfig() {
        for key, config in this.Games {
            if (Type(config) == "Map" && config.Has("LauncherType") && config.Count == 1) {
                this.Games[key] := config["LauncherType"]
            }
        }

        return super.SaveConfig()
    }
}
