#Include ConfigBase.ahk

class FileConfig extends ConfigBase {
    configPathValue := ""

    ConfigPath[] {
        get {
            return this.configPathValue
        }
        set {
            this.configPathValue := value
        }
    }

    __New(app, configPath := "", extension := ".conf", autoLoad := true) {
        super.__New(app)

        if (configPath == "") {
            configPath := app.appDir . "\" . app.appName . extension
        }

        this.ConfigPath := configPath

        if (autoLoad and this.ConfigPath != "") {
            this.LoadConfig()
        }
    }

    LoadConfig() {

    }

    SaveConfig() {
        
    }
}
