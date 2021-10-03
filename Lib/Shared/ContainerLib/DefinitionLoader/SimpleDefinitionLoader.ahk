class SimpleDefinitionLoader extends DefinitionLoaderBase {
    serviceDefinitions := ""
    parameterDefinitions := Map()

    __New(serviceDefinitions, parameterDefinitions := "") {
        this.serviceDefinitions := serviceDefinitions

        if (parameterDefinitions) {
            this.parameterDefinitions := parameterDefinitions
        }
    }

    LoadServiceDefinitions() {
        return this.serviceDefinitions
    }

    LoadParameterDefinitions() {
        return this.parameterDefinitions
    }
}
