class ModuleBase {
    moduleInfo := ""
    config := ""
    key := ""

    __New(key, moduleInfo, config) {
        this.key := key
        this.moduleInfo := moduleInfo
        this.config := config
    }

    IsEnabled() {
        return this.config.Has("enabled") ? this.config["enabled"] : false
    }

    IsCore() {
        return (this.config.Has("core") && this.config["core"])
    }

    GetConfigValue(key, defaultValue := "") {
        val := defaultValue

        if (this.config && this.config.Has(key)) {
            val := this.config[key]
        }

        return val
    }

    GetVersion() {
        return this.moduleInfo.Has("version") ? this.moduleInfo["version"] : ""
    }

    GetServiceFiles() {
        serviceFiles := []
        base := this.moduleInfo["dir"] . "\" . this.moduleInfo["name"]

        possiblePaths := [
            base . ".module.json",
            base . ".services.json"
        ]

        for index, filePath in possiblePaths {
            if (FileExist(filePath)) {
                serviceFiles.Push(filePath)
            }
        }

        return serviceFiles
    }

    GetModuleIcon() {
        moduleIcon := ""

        if (this.moduleInfo.Has("icon") && this.moduleInfo["icon"]) {
            moduleIcon := this.moduleInfo["icon"]
        } else {
            pathBase := this.moduleInfo["dir"] . "\" . this.moduleInfo["name"]
            resourceBase := pathBase . "\Resources\" . this.moduleInfo["name"]

            for index, ext in [".ico", ".icon.png", ".icon.jpg", ".icon.bmp"] {
                if (FileExist(pathBase . ext)) {
                    moduleIcon := pathBase . ext
                    break
                } else if (FileExist(resourceBase . ext)) {
                    moduleIcon := resourceBase . ext
                    break
                }
            }
        }

        return moduleIcon
    }

    GetDependencies() {
        return this.moduleInfo.Has("dependencies") ? this.moduleInfo["dependencies"] : []
    }
}
