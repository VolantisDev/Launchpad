class ServiceDefinitionsEvent extends EventBase {
    servicesObj := Map()
    parametersObj := Map()
    configObj := Map()

    Services {
        get => this.servicesObj
    }

    Parameters {
        get => this.parametersObj
    }

    Config {
        get => this.configObj
    }

    __New(eventName, services := "", parameters := "", config := "") {
        if (services) {
            this.servicesObj := services
        }

        if (parameters) {
            this.parametersObj := parameters
        }

        if (config) {
            this.configObj := config
        }
        
        super.__New(eventName)
    }

    DefineService(name, definition) {
        this.Services[name] := definition
    }

    DefineParameter(name, definition) {
        this.Parameters[name] := definition
    }

    DefineServices(services) {
        for name, definition in services {
            this.DefineService(name, definition)
        }
    }

    DefineParameters(parameters) {
        for name, definition in parameters {
            this.DefineParameter(name, definition)
        }
    }
}
