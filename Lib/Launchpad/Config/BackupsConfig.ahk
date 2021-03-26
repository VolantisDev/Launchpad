class BackupsConfig extends JsonConfig {
    primaryConfigKey := "Backups"

    Backups {
        get => this.config[this.primaryConfigKey]
        set => this.config[this.primaryConfigKey] := value
    }
}
