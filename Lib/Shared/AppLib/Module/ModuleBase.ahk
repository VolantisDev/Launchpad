class ModuleBase {
    moduleName := ""
    app := ""

    __New(app) {
        this.app := app
        if (!this.moduleName) {
            this.moduleName := SubStr(Type(this), 1, -7)
        }
        
    }

    GetDependencies() {
        return []
    }

    GetSubscribers() {
        return Map()
    }
}
