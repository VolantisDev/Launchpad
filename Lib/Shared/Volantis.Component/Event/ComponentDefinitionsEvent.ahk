class ComponentDefinitionsEvent extends ComponentManagerEvent {
    services := ""
    parameters := ""

    __New(eventName, componentManager, services := "", parameters := "") {
        if (!services) {
            services := Map()
        }

        if (!parameters) {
            parameters := Map()
        }

        this.services := services
        this.parameters := parameters

        super.__New(eventName, componentManager)
    }

    GetDefinitions() {
        return this.services
    }

    SetDefinition(componentId, componentDefinition) {
        this.services[componentId] := componentDefinition
    }

    SetDefinitions(services) {
        for key, definition in services {
            this.SetDefinition(key, definition)
        }
    }

    GetParameters() {
        return this.parameters
    }

    SetParameter(name, value := "") {
        this.parameters[name] := value
    }

    SetParameters(parameters) {
        for parameter, value in parameters {
            this.parameters[parameter] := value
        }
    }
}
