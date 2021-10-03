class ModuleManager extends ConfigurableContainerServiceBase {
    app := ""
    eventManagerObj := ""
    idGeneratorObj := ""
    dataDir := ""
    discoverEvent := Events.MODULES_DISCOVER
    discoverAlterEvent := Events.MODULES_DISCOVER_ALTER
    loadEvent := Events.MODULE_LOAD
    loadAlterEvent := Events.MODULE_LOAD_ALTER
    moduleDirs := []
    classSuffix := "Module"

    __New(app, eventManagerObj, idGeneratorObj, configPath, dataDir, moduleDirs := "", defaultModuleInfo := "", defaultModules := "") {
        this.app := app
        this.eventManagerObj := eventManagerObj
        this.idGeneratorObj := idGeneratorObj
        this.dataDir := dataDir

        configObj := ModuleConfig(app, configPath, true)
        
        if (moduleDirs) {
            if (Type(moduleDirs) == "String") {
                moduleDirs := [moduleDirs]
            }

            this.moduleDirs := moduleDirs
        }

        super.__New(configObj, configObj.primaryConfigKey, defaultModuleInfo, defaultModules, false)
    }

    CreateDiscoverer() {
        searchDirs := this.GetModuleParentDirs()
        coreDirs := this.GetCoreModuleDirs()

        return ModuleDiscoverer(this, searchDirs, coreDirs)
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

            eventMgr := this.eventManagerObj

            if (subscribers) {
                for eventName, eventSubscribers in subscribers {
                    if (eventSubscribers) {
                        for index, subscriber in eventSubscribers {
                            eventMgr.Register(eventName, this.idGeneratorObj.Generate(), subscriber)
                        }
                    }
                }
            }
        }
    }

    GetModuleServiceFiles() {
        modules := this.GetAll()

        serviceFiles := []

        for key, module in modules {
            moduleFiles := module.GetServiceFiles()

            if (moduleFiles) {
                if (Type(moduleFiles) == "String") {
                    moduleFiles := [moduleFiles]
                }

                for index, serviceFile in moduleFiles {
                    serviceFiles.Push(serviceFile)
                }
            }
        }

        return serviceFiles
    }

    UpdateModuleIncludes(outputFile, testsFile := "") {
        buildTestFiles := (testsFile && !A_IsCompiled)
        updated := false
        this.moduleDirs := this.GetModuleDirs(false)

        tmpFile := outputFile . ".tmp"
        includeBuilder := this.GetModuleIncludeBuilder()
        includeWriter := this.GetModuleIncludeWriter(tmpFile)
        includes := includeBuilder.BuildIncludes()
        updated := includeWriter.WriteIncludes(includes)

        if (buildTestFiles) {
            testsTmpFile := testsFile . ".tmp"
            testBuilder := this.GetModuleTestIncludeBuilder()
            testWriter := this.GetModuleIncludeWriter(testsTmpFile)
            testIncludes := testBuilder.BuildIncludes()
            testsUpdated := testWriter.WriteIncludes(testIncludes)

            if (testsUpdated && !updated) {
                updated := true
            }
        }

        return updated
    }

    GetModuleIncludeBuilder() {
        return AhkIncludeBuilder(
            this.GetModuleDirs(),
            "*.ahk",
            true,
            false,
            ".test.ahk"
        )
    }

    GetModuleTestIncludeBuilder() {
        return AhkIncludeBuilder(
            this.GetModuleDirs(),
            "*.test.ahk"
        )
    }

    GetModuleIncludeWriter(outputFile) {
        return AhkIncludeWriter(outputFile)
    }

    GetModuleDirs(includeCoreModules := true) {
        moduleDirs := []

        componentInfo := this.DiscoverComponents()

        for key, moduleInfo in componentInfo {


            if (moduleInfo && Type(moduleInfo) == "Map" && moduleInfo.Has("file") && moduleInfo["file"]) {
                SplitPath(moduleInfo["file"], &moduleDir)

                if (DirExist(moduleDir) && (includeCoreModules || !moduleInfo.Has("core") || !moduleInfo["core"])) {
                    moduleDirs.Push(moduleDir)
                }
            }
        }

        return moduleDirs
    }

    GetCoreModuleDirs() {
        return [this.app.appDir . "\Lib\Modules"]
    }

    GetModuleParentDirs() {
        dirs := this.GetCoreModuleDirs()

        sharedDir := this.dataDir . "\Modules"

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
