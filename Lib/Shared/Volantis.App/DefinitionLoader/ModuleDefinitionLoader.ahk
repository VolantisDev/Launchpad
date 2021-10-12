class ModuleDefinitionLoader extends ClassDiscoveryDefinitionLoader {
    factory := ""
    moduleConfig := ""
    coreModuleParentDirs := ""
    defaultModules := Map()
    
    __New(factory, moduleConfig, searchDirs, coreModuleParentDirs := "", defaultModules := "") {
        this.factory := factory
        this.moduleConfig := moduleConfig

        if (coreModuleParentDirs && Type(coreModuleParentDirs) == "String") {
            coreModuleParentDirs := [coreModuleParentDirs]
        }

        if (defaultModules) {
            for key, moduleInfo in defaultModules {
                this.defaultModules[key] := moduleInfo
            }
        }

        this.coreModuleParentDirs := coreModuleParentDirs

        for index, dir in coreModuleParentDirs {
            searchDirs.Push(dir)
        }

        super.__New(searchDirs, ".module.ahk", "Module", true)
    }
    
    DiscoverServiceDefinitions(fileName, filePath) {
        services := Map()
        serviceName := this.getServiceName(fileName, filePath)
        className := this.getClassName(fileName, filePath)
        isEnabled := this.ModuleIsEnabled(serviceName, fileName, filePath)

        services[serviceName] := Map(
            "factory", ObjBindMethod(this.factory, "CreateModule"),
            "arguments", [serviceName, className, filePath],
            "core", this.IsCoreModule(fileName, filePath),
            "enabled", isEnabled,
            "tags", []
        )

        if (isEnabled) {
            services[serviceName]["tags"].Push("event_subscriber")
        }

        return services
    }

    ModuleIsEnabled(moduleName, fileName, filePath) {
        isEnabled := this.defaultModules.Has(moduleName)
        
        if (!isEnabled) {
            parameters := this.moduleConfig.Has(moduleName) ? this.moduleConfig[moduleName] : Map()

            isEnabled := parameters.Has("enabled") && parameters["enabled"]
        }

        return isEnabled
    }

    ; Module config is supplimented from the config.modules service, so this is just the default
    DiscoverParameterDefinitions(fileName, filePath) {
        parameters := super.DiscoverParameterDefinitions(fileName, filePath)
        serviceName := this.getServiceName(fileName, filePath)

        if (this.defaultModules.Has(serviceName)) {
            moduleInfo := this.defaultModules[serviceName]

            if (!moduleInfo) {
                moduleInfo := Map("enabled", true)
            }

            if (Type(moduleInfo) == "String") {
                moduleInfo := Map(
                    "class", moduleInfo,
                    "enabled", true
                )
            }

            for key, val in moduleInfo {
                parameters["module." . serviceName . "." . key] := val
            }
        }

        if (!parameters.Count) {
            parameters["module." . serviceName . ".enabled"] := false
        }

        return parameters
    }

    IsCoreModule(fileName, filePath) {
        isCore := false

        if (this.coreModuleParentDirs) {
            for index, parentDir in this.coreModuleParentDirs {
                coreLen := StrLen(parentDir)
                if (SubStr(filePath, 1, coreLen) == parentDir) {
                    isCore := true
                    break
                }
            }
        }

        return isCore
    }
}
