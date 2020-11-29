class LauncherConfig extends JsonConfig {
    primaryConfigKey := "Games"
    gameDefaults := Map()

    Games[] {
        get => (this.config["Games"] != "") ? this.config["Games"] : Map()
        set => this.config["Games"] := value
    }

    LoadConfig() {
        result := super.LoadConfig()

        for key, config in this.Games {
            if (Type(config) == "String") {
                this.Games[key] := Map("LauncherType", config)
            }
        }

        return result
    }

    SaveConfig() {
        for key, config in this.Games {
            if (Type(config) == "Map" and config.Has("LauncherType") and config.Count == 1) {
                this.Games[key] := config["LauncherType"]
            }
        }

        return super.SaveConfig()
    }
}
