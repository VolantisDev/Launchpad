class ConfigBase {
    appNameValue := ""
    appDirValue := ""
    app := ""

    AppName[] {
        get {
            return this.appNameValue
        }
        set {
            this.appNameValue := value
        }
    }

    AppDir[] {
        get {
            return this.appDirValue
        }
        set {
            return this.appDirValue := value
        }
    }

    __New(app) {
        this.appNameValue := app.appName
        this.appDirValue := app.appDir
        this.app := app
    }    
}
