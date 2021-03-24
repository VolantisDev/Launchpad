class BackupsConfig extends JsonConfig {
    primaryConfigKey := "Backups"
    configKey := "BackupsConfig"

    Backups {
        get => this.config["Backups"]
        set => this.config["Backups"] := value
    }

    LoadConfig() {
        result := super.LoadConfig()

        if (!this.config.Has("Backups")) {
            this.config["Backups"] := Map()
        }

        return result
    }
}
