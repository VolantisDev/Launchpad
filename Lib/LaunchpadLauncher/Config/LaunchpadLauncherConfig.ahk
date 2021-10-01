class LaunchpadLauncherConfig extends ConfigBase {
    Config := Map()
    LauncherConfig := Map()
    GameConfig := Map()
    ConfigPath := ""
    
    __New(app, config, launcherConfig, gameConfig, configPath := "") {
        super.__New(app)
        this.Config := config
        this.LauncherConfig := launcherConfig
        this.GameConfig := gameConfig
        this.configPath := configPath
    }

    SetValues(values) {
        for key, value in values {
            this.%key% := value
        }
    }
}
