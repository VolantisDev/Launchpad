class StructuredDataDefinitionLoader extends DefinitionLoaderBase {
    serviceStructuredData := ""
    servicesKey := ""
    parameterStructuredData := ""
    parametersKey := ""

    __New(serviceStructuredData, parameterStructuredData := "", servicesKey := "", parametersKey := "") {
        this.serviceStructuredData := serviceStructuredData
        this.servicesKey := servicesKey ? servicesKey : "services"
        this.parametersKey := parametersKey ? parametersKey : "parameters"
        this.parameterStructuredData := parameterStructuredData
    }

    LoadServiceDefinitions() {
        return this.LoadFromStructuredData(this.serviceStructuredData, this.servicesKey)
    }

    LoadParameterDefinitions() {
        structuredData := this.parameterStructuredData ? this.parameterStructuredData : this.serviceStructuredData
        return this.LoadFromStructuredData(structuredData, this.parametersKey)
    }

    LoadFromStructuredData(structuredData, key := "", ignoreFailure := true) {
        if (!HasBase(structuredData, StructuredDataBase.Prototype)) {
            throw ContainerException("A subclass of StructuredDataBase must be provided to load services from. Received: " . Type(structuredData))
        }

        dataObj := structuredData.Obj

        if (!HasBase(dataObj, Map.Prototype)) {
            throw ContainerException("Services can only be loaded from a Map object")
        }

        if (key) {
            if (dataObj.Has(key)) {
                dataObj := dataObj[key]
            } else {
                if (!ignoreFailure) {
                    throw ContainerException("Cannot load data from non-existant key " . key . " in " . Type(this))
                }

                dataObj := Map()
            }
        }

        return dataObj
    }
}
