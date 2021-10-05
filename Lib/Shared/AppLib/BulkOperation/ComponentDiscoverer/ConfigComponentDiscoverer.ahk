class ConfigComponentDiscoverer extends ComponentDiscovererBase {
    configObj := ""
    parentKey := ""

    __New(componentManager, configObj, parentKey := "", owner := "") {
        this.configObj := configObj
        this.parentKey := parentKey

        super.__New(componentManager, owner)
    }

    DiscoverComponents() {
        parentKey := this.parentKey

        for componentName, componentConfig in this.configObj[parentKey] {
            this.DiscoverComponent(componentName, componentConfig)
        }

        super.DiscoverComponents()
    }

    DiscoverComponent(componentName, componentConfig) {
        this.results[componentName] := componentConfig
    }
}
