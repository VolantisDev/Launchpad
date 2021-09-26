class ModuleConfig extends JsonConfig {
    primaryConfigKey := "Modules"

    Modules {
        get => this.config[this.primaryConfigKey]
        set => this.config[this.primaryConfigKey] := value
    }
}
