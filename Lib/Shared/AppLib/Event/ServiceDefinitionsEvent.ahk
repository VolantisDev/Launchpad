class ServiceDefinitionsEvent extends EventBase {
    servicesObj := Map()
    configObj := Map()

    Services {
        get => this.servicesObj
    }

    Config {
        get => this.configObj
    }

    __New(eventName, services := "", config := "") {
        if (services) {
            this.servicesObj := services
        }

        if (config) {
            this.configObj := config
        }
        
        super.__New(eventName)
    }

    DefineService(name, definition) {
        this.servicesObj[name] := definition
    }
}
