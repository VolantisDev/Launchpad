class ModuleManager extends ConfigurableContainerServiceBase {
    discoverEvent := Events.MODULES_DISCOVER
    discoverAlterEvent := Events.MODULES_DISCOVER_ALTER
    loadEvent := Events.MODULE_LOAD
    loadAlterEvent := Events.MODULE_LOAD_ALTER
    moduleDirs := []

    __New(app, configPath, moduleDirs := "", defaultModuleInfo := "", defaultModules := "", autoLoad := true) {
        configObj := ModuleConfig(app, configPath, true)
        
        if (moduleDirs) {
            if (Type(moduleDirs) == "String") {
                moduleDirs := [moduleDirs]
            }

            this.moduleDirs := moduleDirs
        }

        super.__New(app, configObj, configObj.primaryConfigKey, defaultModuleInfo, defaultModules, autoLoad)
    }

    CreateDiscoverer() {
        searchDirs := this.GetModuleDirs()
        filePattern := "*.module.ahk"

        return ClassFileComponentDiscoverer(this, searchDirs, filePattern)
    }

    CreateLoader(componentInfo) {
        return ClassComponentLoader(this, componentInfo)
    }

    LoadComponents() {
        if (!this.componentsLoaded) {
            ; TODO: Calculate dependencies and stop if they are not met
            super.LoadComponents()
            this.RegisterSubscribers()
        }
    }
    
    DispatchEvent(eventName, eventObj, extra := "", hwnd := "") {
        modules := this.GetAll()

        for key, module in modules {
            module.DispatchEvent(eventName, eventObj, extra, hwnd)
        }
    }

    CalculateDependencies() {
        requiredModules := []

        for key, module in this.GetAll() {
            deps := module.GetDependencies()

            for depIndex, depName in deps {
                exists := false
                for reqIndex, reqName in requiredModules {
                    if (depName == reqName) {
                        exists := true
                        break
                    }
                }

                if (!exists) {
                    requiredModules.Push(depName)
                }
            }
        }

        return requiredModules
    }

    CalculateMissingDependencies() {
        requiredModules := this.CalculateDependencies()
        missingModules := []

        for reqIndex, reqName in requiredModules {
            if (!this.Exists(reqName)) {
                missingModules.Push(reqName)
            }
        }

        return missingModules
    }

    RegisterSubscribers() {
        modules := this.GetAll()

        for key, module in modules {
            subscribers := module.GetSubscribers()

            eventMgr := this.app.Service("EventManager")

            if (subscribers) {
                for eventName, eventSubscribers in subscribers {
                    if (eventSubscribers) {
                        for index, subscriber in eventSubscribers {
                            eventMgr.Register(eventName, this.app.Service("IdGenerator").Generate(), subscriber)
                        }
                    }
                }
            }
        }
    }

    GetModuleDirs() {
        dirs := []
        sharedDir := this.app.dataDir . "\Modules"

        if (DirExist(sharedDir)) {
            dirs.Push(sharedDir)
        }

        if (this.moduleDirs) {
            for index, moduleDir in this.moduleDirs {
                if (DirExist(moduleDir)) {
                    dirs.Push(moduleDir)
                }
            }
        }

        return dirs
    }
}
