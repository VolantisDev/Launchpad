class ContainerServiceBase {
    eventManagerObj := ""
    container := ""
    defaultComponentInfo := ""
    defaultComponents := ""
    componentsLoaded := false
    discoverEvent := ""
    discoverAlterEvent := ""
    loadEvent := ""
    loadAlterEvent := ""
    loader := ""
    discoverer := ""
    classSuffix := ""

    __New(defaultComponentInfo := "", defaultComponents := "", autoLoad := true) {
        this.defaultComponentInfo := defaultComponentInfo
        this.defaultComponents := defaultComponents
        this.container := ServiceComponentContainer(defaultComponents)

        if (autoLoad) {
            this.LoadComponents()
        }
    }

    GetDiscoverer() {
        if (!this.discoverer) {
            this.discoverer := this.CreateDiscoverer()
        }

        return this.discoverer
    }

    CreateDiscoverer() {
        return  ""
    }

    GetLoader(componentInfo) {
        if (!this.loader) {
            this.loader := this.CreateLoader(componentInfo)
        } else {
            this.loader.componentInfo := componentInfo
        }

        return this.loader
    }

    CreateLoader(componentInfo) {
        return SimpleComponentLoader(this, componentInfo)
    }

    LoadComponents() {
        if (!this.componentsLoaded) {
            componentInfo := this.defaultComponentInfo ? this.defaultComponentInfo : Map()

            discoverer := this.GetDiscoverer()

            if (discoverer) {
                success := discoverer.Run()

                if (success) {
                    componentInfo := discoverer.GetResults()
                }
            }

            loader := this.GetLoader(componentInfo)

            if (!loader) {
                throw AppException("Component loader not found")
            }

            success := loader.Run()
            components := success ? loader.GetResults() : Map()
            this.container := ServiceComponentContainer(components)
            this.componentsLoaded := true
        }
    }

    Get(key) {
        return this.container.Get(key)
    }

    Exists(key) {
        return this.container.Has(key)
    }

    GetAll() {
        return this.container.Items
    }

    Set(key, componentObj) {
        this.container.Set(key, componentObj)
    }

    Remove(key) {
        this.container.Delete(key)
    }

    GetComponentConfig(key, componentInfo) {
        return Map()
    }
}
