class FileConfig extends ConfigBase {
    configPathValue := ""

    ConfigPath[] {
        get => this.configPathValue
        set => this.configPathValue := value
    }

    __New(app, configPath := "", extension := ".conf", autoLoad := true) {
        InvalidParameterException.CheckTypes("ValidateLaunchersOp", "configPath", configPath, "", "extension", extension, "")
        this.ConfigPath := configPath != "" ? configPath : app.appDir . "\" . app.appName . extension
        super.__New(app)

        if (autoLoad && this.ConfigPath != "") {
            this.LoadConfig()
        }
    }
}
