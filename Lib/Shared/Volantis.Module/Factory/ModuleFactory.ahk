class ModuleFactory {
    container := ""
    structuredData := ""
    moduleConfig := ""
    classMap := Map()
    
    __New(container, structuredData, moduleConfig) {
        this.container := container
        this.structuredData := structuredData
        this.moduleConfig := moduleConfig
    }

    CreateServiceDefinitions(key, file, isCore := false, enabled := true) {
        return Map(
            "module_info." . key, Map(
                "class", "FileModuleInfo",
                "arguments", [file, this.structuredData, this.container, key]
            ),
            "module_config." . key, Map(
                "class", "ChildConfig",
                "arguments", [this.moduleConfig, key]
            ),
            "module." . key, Map(
                "class", this.classMap.Has(key) ? this.classMap[key] : "SimpleModule",
                "arguments", [key, "@module_info." . key, "@module_config." . key],
                "file", file,
                "enabled", enabled,
                "core", isCore,
                "tags", ["module"]
            )
        )
    }

    CreateModuleFromFile(key, file) {
        moduleClass := this.classMap.Has(key) ? this.classMap[key] : "SimpleModule"

        moduleInfo := Map(
            "key", key,
            "name", key,
            "file", file,
            "class", moduleClass,
        )

        if (!HasMethod(%moduleClass%)) {
            throw AppException("Module class " . moduleClass . " is not loaded or is not callable.`n`nYou might need to rebuild your module includes.")
        }

        return %moduleClass%(
            this.container,
            moduleInfo,
            this.GetModuleConfig(key, file)
        )
    }

    GetModuleConfig(key, file) {
        config := ""

        if (this.moduleConfig.Has(key)) {
            return this.moduleConfig[key]
        } else {
            config := Map("enabled", false)
        }

        return config
    }
}
