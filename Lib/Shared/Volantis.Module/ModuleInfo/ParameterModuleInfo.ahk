class ParameterModuleInfo extends ModuleInfoBase {
    container := ""
    parameterKey := ""
    parametersLoaded := false

    __New(container, key) {
        this.container := container
        this.parameterKey := "modules." . key
        moduleInfo := this.GetParameters()

        if (!HasBase(moduleInfo, Map.Prototype)) {
            moduleInfo := Map("enabled", moduleInfo)
        }

        super.__New(key, moduleInfo)
    }

    GetParameters() {
        parameters := this.container.HasParameter(this.parameterKey) ? this.container.GetParameter(this.parameterKey) : Map()

        if (!HasBase(parameters, Map.Prototype)) {
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
