class ServiceContainer extends ContainerBase {
    parametersObj := Map()

    Parameters {
        get => this.parametersObj
    }
    
    __New(items := "", parameters := "") {
        if (parameters) {
            this.parametersObj := parameters
        }

        super.__New(items)
    }

    Get(key) {
        serviceObj := super.Get(key)

        if (!serviceObj) {
            throw ServiceNotFoundException("Service '" . key . "' has not been loaded")
        }

        return serviceObj
    }
}
