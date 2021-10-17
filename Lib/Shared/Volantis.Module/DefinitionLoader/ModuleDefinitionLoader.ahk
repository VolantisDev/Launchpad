class ModuleDefinitionLoader extends FileDiscoveryDefinitionLoaderBase {
    factory := ""
    moduleConfig := ""
    coreModuleParentDirs := ""
    defaultModules := Map()
    
    __New(factory, moduleConfig, searchDirs, coreModuleParentDirs := "", defaultModules := "") {
        this.factory := factory
        this.moduleConfig := moduleConfig

        if (coreModuleParentDirs) {
            if (Type(coreModuleParentDirs) == "String") {
                coreModuleParentDirs := [coreModuleParentDirs]
            }

            for index, dir in coreModuleParentDirs {
                searchDirs.Push(dir)
            }

            this.coreModuleParentDirs := coreModuleParentDirs
        }

        if (defaultModules) {
            for key, moduleInfo in defaultModules {
                if (!IsObject(moduleInfo)) {
                    moduleInfo := Map("enabled", !!(moduleInfo))
                }

                this.defaultModules[key] := moduleInfo
            }
        }

        super.__New(searchDirs, ".module.json", true)
    }
    
    DiscoverServiceDefinitions(baseName, fileName, filePath) {
        isCore := this.IsCoreModule(fileName, filePath)
        isEnabled := this.ModuleIsEnabled(baseName, fileName, filePath)
        return this.factory.CreateServiceDefinitions(baseName, filePath, isCore, isEnabled)
    }

    ModuleIsEnabled(moduleName, fileName, filePath) {
        isEnabled := this.defaultModules.Has(moduleName)
        parameters := this.moduleConfig.Has(moduleName) ? this.moduleConfig[moduleName] : Map()
        
        if (parameters.Has("enabled")) {
            isEnabled := parameters["enabled"]
        }

        return isEnabled
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
