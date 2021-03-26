class ServiceContainer extends ContainerBase {
    Get(key) {
        serviceObj := super.Get(key)

        if (!serviceObj) {
            throw ServiceNotFoundException.new("Service '" . key . "' has not been loaded")
        }

        return serviceObj
    }
}
