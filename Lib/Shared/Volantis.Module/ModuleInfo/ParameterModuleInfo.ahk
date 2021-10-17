class ParameterModuleInfo extends ModuleInfoBase {
    container := ""
    parameterKey := ""

    __New(container, key) {
        this.container := container
        this.parameterKey := "modules." . key
        moduleInfo := this.GetParameters()

        if (Type(moduleInfo) != "Map") {
            moduleInfo := Map("enabled", moduleInfo)
        }

        super.__New(key, moduleInfo)
    }

    GetParameters() {
        parameters := ""

        if (this.container.HasParameter(this.parameterKey)) {
            parameters := this.container.GetParameter(this.parameterKey)
        } else {
            parameters := this.LoadParameters()
        }

        return parameters
    }

    LoadParameters() {
        return Map()
    }
}
