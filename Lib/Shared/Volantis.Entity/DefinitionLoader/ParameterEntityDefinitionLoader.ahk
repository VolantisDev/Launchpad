class ParameterEntityDefinitionLoader extends EntityDefinitionLoaderBase {
    container := ""
    parameterKey := ""
    
    __New(container, parameterKey, factoryObj) {
        this.container := container
        this.parameterKey := parameterKey

        super.__New(factoryObj)
    }

    static Create(entityTypeId, definition, container) {
        className := this.Prototype.__Class
        manager := container.Get("manager.entity_type")

        return %className%(
            container,
            definition["definition_loader_parameter_key"],
            manager.GetFactory(entityTypeId)
        )
    }

    LoadServiceDefinitions() {
        services := Map()

        if (this.container.HasParameter(this.parameterKey)) {
            params := this.container.GetParameter(this.parameterKey)

            for id, data in params {
                services[id] := this.factoryObj.CreateServiceDefinition(id, data, "", true)
            }
        }

        return services
    }
}
