class ModuleBase {
    container := ""
    moduleInfo := ""
    config := ""

    __New(container, moduleInfo, config := "") {
        this.container := container
        this.config := config

        if (moduleInfo["file"] && (!moduleInfo.Has("dir") || !moduleInfo["dir"])) {
            SplitPath(moduleInfo["file"], &moduleDir)
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

    GetServiceFiles() {
        serviceFiles := []

        filePath := this.moduleInfo["dir"] . "\" . this.moduleInfo["name"] . ".services.json"

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
