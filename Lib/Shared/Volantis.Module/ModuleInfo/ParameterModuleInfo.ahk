class ParameterModuleInfo extends ModuleInfoBase {
    container := ""
    parameterKey := ""
    parametersLoaded := false

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
        parameters := this.container.HasParameter(this.parameterKey) ? this.container.GetParameter(this.parameterKey) : Map()

        if (Type(parameters) != "Map") {
            parameters := Map("enabled", !!parameters)
        }

        if (!this.parametersLoaded) {
            for key, val in this.LoadParameters() {
                parameters[key] := val
            }
        }

        return parameters
    }

    LoadParameters() {
        this.parametersLoaded := true
        return Map()
    }
}
