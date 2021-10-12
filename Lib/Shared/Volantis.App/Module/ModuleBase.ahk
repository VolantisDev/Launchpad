class ModuleBase {
    container := ""
    moduleInfo := ""
    config := ""

    __New(container, moduleInfo, config := "") {
        this.container := container
        this.config := config

        if (moduleInfo["file"] && (!moduleInfo.Has("dir") || !moduleInfo["dir"])) {
            SplitPath(moduleInfo["file"],, &moduleDir)
            moduleInfo["dir"] := moduleDir
        }

        if (!moduleInfo.Has("name") || !moduleInfo["name"]) {
            moduleName := Type(this)
            suffix := "Module"
            len := StrLen(suffix)
            
            if (SubStr(moduleName, -len) == suffix) {
                moduleName := SubStr(moduleName, 1, -len)
            }
            
            moduleInfo["name"] := moduleName
        }

        this.moduleInfo := moduleInfo
    }

    IsEnabled() {
        return this.config.Has("enabled") ? this.config["enabled"] : false
    }

    IsCore() {
        return true
    }

    GetConfigValue(key) {
        val := ""

        if (this.config && this.config.Has(key)) {
            val := this.config[key]
        }

        return val
    }

    GetVersion() {
        version := ""

        if (this.moduleInfo.Has("version")) {
            version := this.moduleInfo["version"]
        } else {
            version := this.container.GetApp().Version
        }

        return version
    }

    GetServiceFiles() {
        serviceFiles := []

        filePath := this.moduleInfo["dir"] . "\" . this.moduleInfo["name"] . ".services.json"

        if (FileExist(filePath)) {
            serviceFiles.Push(filePath)
        }

        return serviceFiles
    }

    GetModuleIcon() {
        moduleIcon := ""

        pathBase := this.moduleInfo["dir"] . "\" . this.moduleInfo["name"]

        searchPaths := [
            pathBase . ".ico",
            pathBase . ".icon.png",
            pathBase . ".icon.jpg",
            pathBase . ".icon.bmp",
            pathBase . "\Resources\" . this.moduleInfo["name"] . ".ico",
            pathBase . "\Resources\" . this.moduleInfo["name"] . ".icon.png",
            pathBase . "\Resources\" . this.moduleInfo["name"] . ".icon.jpg",
            pathBase . "\Resources\" . this.moduleInfo["name"] . ".icon.bmp",
        ]

        for index, filePath in searchPaths {
            if (FileExist(filePath)) {
                moduleIcon := filePath
            }
        }

        return moduleIcon
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
