class ModuleManager extends ComponentManagerBase {
    configObj := ""
    moduleConfig := ""
    classSuffix := "Module"

    __New(container, eventMgr, notifierObj, configObj, moduleConfig, definitionLoaders := "") {
        this.configObj := configObj
        this.moduleConfig := moduleConfig

        super.__New(container, "module.", eventMgr, notifierObj, ModuleBase, definitionLoaders)
    }

    ValidateComponentDependencies(services, parameters, stage) {
        if (stage == "after") {
            missingDeps := this.CalculateMissingDependencies()

            if (missingDeps.Length) {
                missing := ""

                for index, dep in missingDeps {
                    if (missing) {
                        missing .= ", "
                    }

                    missing .= dep
                }

                throw AppException("There are missing module dependencies: " . missing)
            }
        }
    }

    LoadComponents(reloadComponents := false) {
        super.LoadComponents(reloadComponents)

        save := false

        moduleParams := this.container.HasParameter("modules") ? this.container.GetParameter("modules") : Map()

        for key, config in moduleParams {
            if (!this.moduleConfig.Has(key) || !this.moduleConfig[key].Count) {
                if (IsNumber(config)) {
                    config := Map("enabled", !!config)
                }

                this.moduleConfig[key] := config
                save := true
            }
        }

        if (save) {
            this.moduleConfig.SaveConfig()
        }
    }

    _loadDefinitions(loader) {
        return this.container.LoadDefinitions(loader, true)
    }

    Enable(keys) {
        return this.Toggle(keys, this.CalculateDependencies(keys), true)
    }

    Disable(keys) {
        return this.Toggle(keys, this.CalculateDependents(keys), false)
    }

    FilterDeps(deps, enabled) {
        newDeps := []
        
        for index, key in deps {
            if (enabled != this.IsEnabled(key)) {
                newDeps.Push(key)
            }
        }

        return newDeps
    }

    Toggle(keys, deps, enabled := true, enableConfirmationDialog := true) {
        keys := HasBase(keys, Array.Prototype) ? keys.Clone() : [keys]
        shouldToggle := true

        deps := this.FilterDeps(deps, enabled)

        if (deps.Length) {
            shouldToggle := false
            moduleList := this.ListModules(deps)
            response := enableConfirmationDialog ? "No" : "Yes"

            if (enableConfirmationDialog) {
                if (enabled) {
                    response := this.container["manager.gui"].Dialog(Map(
                        "title", "Enable Required Modules",
                        "text", "The following additional required module(s) will also be enabled:`n`n" . moduleList . "`n`nContinue?"
                    ))
                } else {
                    response := this.container["manager.gui"].Dialog(Map(
                        "title", "Disable Dependent Modules",
                        "text", "The following dependent module(s) will also be disabled:`n`n" . moduleList . "`n`nContinue?"
                    ))
                }
            }

            if (response == "Yes") {
                keys.Push(deps*)
                shouldToggle := true
            }
        }

        if (shouldToggle) {
            save := false

            for index, key in keys {
                isEnabled := this.IsEnabled(key)

                if (enabled != isEnabled) {
                    this.SetEnabled(key, enabled, false)
                    save := true
                }
            }

            if (save) {
                this.moduleConfig.SaveConfig()
            }
        }
    }

    ListModules(modules) {
        moduleList := ""

        for index, key in modules {
            if (moduleList) {
                moduleList .= ", "
            }

            moduleList .= key
        }

        return moduleList
    }

    IsEnabled(key) {
        moduleConfig := this.moduleConfig.Has(key) ? this.moduleConfig[key] : Map()

        if (!moduleConfig.Has("enabled") || !moduleConfig["enabled"]) {
            moduleConfig["enabled"] := false
        }

        return moduleConfig["enabled"]
    }

    SetEnabled(key, enabled := true, save := true) {
        moduleConfig := this.moduleConfig.Has(key) ? this.moduleConfig[key] : Map()
        moduleConfig["enabled"] := enabled
        this.moduleConfig[key] := moduleConfig

        if (save) {
            this.moduleConfig.SaveConfig()
        }
    }

    DeleteModule(key) {
        module := this[key]
        deleted := false

        if (module.IsCore()) {
            throw AppException("It is not possible to delete core modules")
        }

        dir := module.moduleInfo["dir"]

        response := this.container.Get("manager.gui").Dialog(Map(
            "title", "Delete " . key,
            "text", "Are you sure you want to delete the module '" . key . "'?`n`nThis will remove the directory " . dir . " and is not reversible. If you want the module back in the future, you will need to install it from scratch.`n`nPress Yes to delete, or No to go back."
        ))

        if (response == "Yes") {
            this.UnloadComponent(key, true)
            DirDelete(dir, true)
            deleted := true
        }

        return deleted
    }

    CalculateDependencies(keys := "") {
        if (keys) {
            if (!HasBase(keys, Array.Prototype)) {
                keys := [keys]
            }
        } else {
            keys := this.Names() ; All enabled modules
        }

        requiredModules := []

        for index, key in keys {
            for depIndex, depName in this.getDependencies(key) {
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

    getDependencies(key) {
        deps := this[key].GetDependencies()

        for index, dep in deps {
            depDeps := this.getDependencies(dep)

            if (depDeps.Length) {
                deps.Push(depDeps*)
            }
        }

        return deps
    }

    CalculateDependents(keys := "") {
        if (keys) {
            if (!HasBase(keys, Array.Prototype)) {
                keys := [keys]
            }
        } else {
            keys := this.Names() ; All enabled modules
        }

        dependentModules := []

        for enabledIndex, enabledKey in this.Names() {
            for index, key in keys {
                if (enabledKey == key) {
                    continue
                }

                for depIndex, depKey in this.getDependencies(enabledKey) {
                    if (key == depKey) {
                        dependentModules.Push(enabledKey)

                        dependents := this.getDependents(enabledKey)

                        if (dependents.Length) {
                            dependentModules.Push(dependents*)
                        }
                        
                        break
                    }
                }
            }
        }

        return dependentModules
    }

    getDependents(key) {
        dependents := []

        for index, enabledKey in this.Names() {
            for depIndex, depKey in this[enabledKey].GetDependencies() {
                if (depKey == key) {
                    dependents.Push(enabledKey, this.getDependents(enabledKey)*)
                    break
                }
            }
        }

        return dependents
    }

    CalculateMissingDependencies(requiredModules := "") {
        if (!requiredModules) {
            requiredModules := this.CalculateDependencies()
        }

        missingModules := []

        for reqIndex, reqName in requiredModules {
            if (!this.Has(reqName)) {
                missingModules.Push(reqName)
            }
        }

        return missingModules
    }

    GetModuleServiceFiles() {
        modules := this.All()

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
        updated := includeWriter.WriteIncludes(includeBuilder.BuildIncludes())

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

    GetModuleDirs(includeCoreModules := true, includeDisabled := false) {
        moduleDirs := []

        componentInfo := this.Query(ContainerQuery.RESULT_TYPE_DEFINITIONS, includeDisabled).Execute()

        for key, moduleInfo in componentInfo {
            if (moduleInfo.Has("file") && moduleInfo["file"]) {
                SplitPath(moduleInfo["file"],, &moduleDir)

                if (DirExist(moduleDir) && (includeCoreModules || !moduleInfo.Has("core") || !moduleInfo["core"])) {
                    moduleDirs.Push(moduleDir)
                }
            }
        }

        return moduleDirs
    }

    GetCoreModuleDirs() {
        return this.configObj["core_module_dirs"]
    }

    GetModuleParentDirs() {
        dirs := this.GetCoreModuleDirs()

        sharedDir := this.dataDir . "\Modules"

        if (DirExist(sharedDir)) {
            dirs.Push(sharedDir)
        }

        if (this.configObj["module_dirs"]) {
            for index, moduleDir in this.configObj["module_dirs"] {
                if (DirExist(moduleDir)) {
                    dirs.Push(moduleDir)
                }
            }
        }

        return dirs
    }
}
