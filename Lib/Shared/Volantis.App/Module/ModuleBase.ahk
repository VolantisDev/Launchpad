class ModuleBase {
    moduleName := ""
    app := ""
    config := ""
    moduleFile := ""
    moduleDir := ""

    __New(app, config := "") {
        this.app := app
        this.config := config

        if (config.Has("file")) {
            this.moduleFile := config["file"]
            SplitPath(config["file"], &moduleDir)
            this.moduleDir := moduleDir
        }
        
        if (!this.moduleName) {
            this.moduleName := SubStr(Type(this), 1, -7)
        }
    }

    GetServiceFiles() {
        serviceFiles := []

        filePath := this.moduleDir . "\" . this.moduleName . ".services.json"

        if (FileExist(filePath)) {
            serviceFiles.Push(filePath)
        }

        return serviceFiles
    }

    GetSupportedTypes() {
        return [] ; An array of application classes or base classes that this module is designed to apply to
    }

    GetDependencies() {
        return []
    }

    GetEventSubscribers() {
        return Map()
    }
}
