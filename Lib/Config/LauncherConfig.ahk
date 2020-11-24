class LauncherConfig extends JsonConfig {
    primaryConfigKey := "Games"
    gameDefaults := Map()

    Games[] {
        get => (this.config["Games"] != "") ? this.config["Games"] : Map()
        set => this.config["Games"] := value
    }

    LoadConfig(configPath := "") {
        result := super.LoadConfig(configPath)

        for key, config in this.Games {
            if (Type(config) == "String") {
                this.Games[key] := Map("launcherType", config)
            }
        }

        return result
    }

    SaveConfig(configPath := "") {
        for key, config in this.Games {
            if (Type(config) == "Map" and config.Has("launcherType") and config.Count == 1) {
                this.Games[key] := config["launcherType"]
            }
        }

        return super.SaveConfig(configPath)
    }
}
