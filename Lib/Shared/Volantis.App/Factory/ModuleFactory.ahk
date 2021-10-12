class ModuleFactory {
    container := ""
    moduleConfig := ""
    classMap := Map()
    
    __New(container, moduleConfig) {
        this.container := container
        this.moduleConfig := moduleConfig
    }

    CreateModule(name, className, file) {
        moduleClass := this.classMap.Has(name) ? this.classMap[name] : className

        moduleInfo := Map(
            "name", name,
            "file", file,
            "class", moduleClass,
        )

        if (!HasMethod(%moduleClass%)) {
            throw AppException("Module class " . moduleClass . " is not loaded or is not callable.`n`nYou might need to rebuild your module includes.")
        }

        return %moduleClass%(
            this.container,
            moduleInfo,
            this.GetModuleConfig(name, file)
        )
    }

    GetModuleConfig(name, file) {
        config := ""

        if (this.moduleConfig.Has(name)) {
            return this.moduleConfig[name]
        } else {
            config := Map("enabled", false)
        }

        return config
    }
}
