class ConfigBase {
    appNameValue := ""
    appDirValue := ""
    app := ""

    AppName[] {
        get => this.appNameValue
        set => this.appNameValue := value
    }

    AppDir[] {
        get => this.appDirValue
        set => this.appDirValue := value
    }

    __New(app) {
        this.appNameValue := app.appName
        this.appDirValue := app.appDir
        this.app := app
    }    
}
