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

    LoadFromMap(dataObj, key := "") {
        if (Type(dataObj) != "Map") {
            throw ContainerException("Services can only be loaded from a Map object")
        }

        if (key) {
            if (!dataObj.Has(key)) {
                throw ContainerException("Cannot load data from non-existant key " . key)
            }

            if (Type(dataObj) != "Map") {
                throw ContainerException("Services key " . key . " is not a valid map")
            }

            dataObj := dataObj[key]
        }

        return dataObj
    }
}
