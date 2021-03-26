class ConfigBase {
    app := ""
    loaded := false
    configKey := ""

    __New(app, extra := "") {
        InvalidParameterException.CheckTypes("ConfigBase", "app", app, "AppBase")
        this.app := app

        if (this.configKey == "") {
            this.configKey := Type(this)
        }
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
        this.loaded := true
        return this
    }

    SaveConfig() {
        return this
    }

    Clone() {
        return super.Clone()
    }
}
