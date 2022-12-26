class EntityDefinitionLoaderBase extends DefinitionLoaderBase {
    factoryObj := ""

    __New(factoryObj) {
        this.factoryObj := factoryObj
    }

    static Create(entityTypeId, definition, container) {
        className := this.Prototype.__Class
        manager := container.Get("manager.entity_type")

        return %className%(
            manager.GetFactory(entityTypeId)
        )
    }

    LoadServiceDefinitions() {
        return Map()
    }

    LoadParameterDefinitions() {
        return Map()
    }
}
