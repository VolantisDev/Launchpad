class MapDefinitionLoader extends DefinitionLoaderBase {
    serviceDefinitions := ""
    servicesKey := ""
    parameterDefinitions := ""
    parametersKey := ""

    __New(serviceDefinitions, parameterDefinitions := "", servicesKey := "", parametersKey := "") {
        this.serviceDefinitions := serviceDefinitions
        this.servicesKey := servicesKey ? servicesKey : "services"
        this.parametersKey := parametersKey ? parametersKey : "parameters"
        this.parameterDefinitions := parameterDefinitions
    }

    LoadServiceDefinitions() {
        return this.LoadFromMap(this.serviceDefinitions, this.servicesKey)
    }

    LoadParameterDefinitions() {
        dataObj := this.parameterDefinitions ? this.parameterDefinitions : this.serviceDefinitions
        return this.LoadFromMap(dataObj, this.parametersKey)
    }

    LoadFromMap(dataObj, key := "", ignoreFailed := true) {
        if (!HasBase(dataObj, Map.Prototype)) {
            throw ContainerException("Services can only be loaded from a Map object")
        }

        if (key) {
            if (dataObj.Has(key)) {
                dataObj := dataObj[key]
            } else {
                dataObj := Map()

                if (!ignoreFailed) {
                    throw ContainerException("Cannot load data from non-existant key " . key)
                }
            }

            if (!HasBase(dataObj, Map.Prototype)) {
                throw ContainerException("Services key " . key . " is not a valid map")
            }
        }

        return dataObj
    }
}
