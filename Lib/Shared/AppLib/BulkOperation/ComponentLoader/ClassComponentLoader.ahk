class ClassComponentLoader extends ComponentLoaderBase {
    defaultClassConfig := Map()

    LoadComponent(key, componentInfo) {
        if (Type(componentInfo) == "String") {
            componentInfo := Map("class", componentInfo)
        }

        className := this.GetComponentClass(key, componentInfo)
        componentConfig := this.GetComponentConfig(key, componentInfo)

        isEnabled := true

        if (componentConfig && componentConfig.Has("enabled")) {
            isEnabled := componentConfig["enabled"]
        }

        if (isEnabled) {
            if (className && IsObject(%className%)) {
                if (HasMethod(%className%, "Create")) {
                    this.results[key] := %className%.Create(this.app.Services, componentConfig)
                } else {
                    this.results[key] := %className%(this.app, componentConfig)
                }
            }
            
            super.LoadComponent(key, componentInfo)

            if (!this.results.Has(key)) {
                throw AppException("Cannot load component " . key)
            }
        }
    }

    GetComponentClass(key, componentInfo) {
        return componentInfo.Has("class") ? componentInfo["class"] : ""
    }

    GetComponentConfig(key, componentInfo) {
        componentConfig := this.defaultClassConfig

        if (componentInfo.Has("config")) {
            for key, val in componentInfo["config"] {
                componentConfig[key] := val
            }
        }

        managerConfig := this.componentManager.GetComponentConfig(key, componentInfo)

        if (managerConfig) {
            for key, val in managerConfig {
                componentConfig[key] := val
            }
        }

        return componentConfig
    }
}
