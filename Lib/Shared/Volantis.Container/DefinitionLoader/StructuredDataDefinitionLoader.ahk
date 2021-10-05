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

    LoadFromStructuredData(structuredData, key := "") {
        if (!structuredData.HasBase(StructuredDataBase)) {
            throw ContainerException("An subclass of StructuredDataBase must be provided to load services from")
        }

        dataObj := structuredData.Obj

        if (Type(dataObj) != "Map") {
            throw ContainerException("Services can only be loaded from a Map object")
        }

        if (key) {
            if (!dataObj.Has(key)) {
                throw ContainerException("Cannot load data from non-existant key " . key)
            }

            dataObj := dataObj[key]
        }

        return dataObj
    }
}
