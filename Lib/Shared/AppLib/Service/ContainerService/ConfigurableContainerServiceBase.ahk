class ConfigurableContainerServiceBase extends ContainerServiceBase {
    configObj := ""
    configKey := ""

    __New(app, configObj, configKey, defaultComponentInfo := "", defaultComponents := "", autoLoad := true) {
        this.configObj := configObj
        this.configKey := configKey

        super.__New(app, defaultComponentInfo, defaultComponents, autoLoad)
    }

    GetComponentConfig(key, componentInfo) {
        componentConfig := super.GetComponentConfig(key, componentInfo)
        configKey := this.configKey
        
        if (this.configObj && this.configObj.%configKey% && this.configObj.%configKey%.Has(key)) {
            for key, val in this.configObj.%configKey%[key] {
                componentConfig[key] := val
            }
        }
        
        return componentConfig
    }
}
