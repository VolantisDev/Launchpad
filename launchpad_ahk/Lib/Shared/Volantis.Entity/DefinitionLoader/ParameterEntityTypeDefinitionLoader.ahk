class ParameterEntityTypeDefinitionLoader extends EntityDefinitionLoaderBase {
    container := ""
    parameterKey := ""
    
    __New(container, parameterKey, factoryObj) {
        this.container := container
        this.parameterKey := parameterKey

        super.__New(factoryObj)
    }

    LoadServiceDefinitions() {
        services := super.LoadParameterDefinitions()

        if (this.container.HasParameter(this.parameterKey)) {
            params := this.container.GetParameter(this.parameterKey)

            for id, data in params {
                if (data && Type(data) == "String") {
                    data := Map("entity_class", data)
                }

                for serviceId, serviceDef in this.factoryObj.CreateServiceDefinitions(id, data) {
                    services[serviceId] := serviceDef
                }
            }
        }

        return services
    }

    LoadParameterDefinitions() {
        parameters := super.LoadParameterDefinitions()

        return parameters
    }
}
