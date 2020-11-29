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
        InvalidParameterException.CheckTypes("ConfigBase", "app", app, "Launchpad")

        this.appNameValue := app.appName
        this.appDirValue := app.appDir
        this.app := app
    }

    SetValues(values) {
        for key, value in values {
            if this.HasProp(key) {
                this.%key% := value
            }
        }

        return this
    }

    LoadConfig() {
        return this
    }

    SaveConfig() {
        return this
    }

    Clone() {
        return super.Clone()
    }
}
