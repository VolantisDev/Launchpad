class EntityTypeDefinitionLoaderBase extends DefinitionLoaderBase {
    factoryObj := ""

    __New(factoryObj) {
        this.factoryObj := factoryObj
    }

    LoadServiceDefinitions() {
        return Map()
    }

    LoadParameterDefinitions() {
        return Map()
    }
}
