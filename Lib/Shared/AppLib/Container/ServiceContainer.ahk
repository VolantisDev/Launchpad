class ServiceContainer extends ContainerBase {
    Get(key) {
        serviceObj := super.Get(key)

        if (!serviceObj) {
            MsgBox(key)
            throw ServiceNotFoundException("Service '" . key . "' has not been loaded")
        }

        return serviceObj
    }
}
