class ModuleBase {
    moduleName := ""
    app := ""
    config := ""

    __New(app, config := "") {
        this.app := app
        this.config := config
        
        if (!this.moduleName) {
            this.moduleName := SubStr(Type(this), 1, -7)
        }
        
    }

    GetSupportedTypes() {
        return [] ; An array of application classes or base classes that this module is designed to apply to
    }

    GetDependencies() {
        return []
    }

    GetSubscribers() {
        return Map()
    }
}
