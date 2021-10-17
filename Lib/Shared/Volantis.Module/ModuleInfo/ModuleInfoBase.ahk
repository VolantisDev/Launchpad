class ModuleInfoBase {
    moduleInfo := Map()

    Key := ""

    Version {
        get => this.Get("version")
    }

    __Item[name] {
        get => this.Get(name)
        set => this.Set(name, value)
    }

    Count {
        get => this.moduleInfo.Count
    }

    __New(key, moduleInfo := "") {
        this.key := key

        if (moduleInfo) {
            this.moduleInfo := moduleInfo
        }

        this.SetDefaults()
    }

    SetDefaults() {
        if (!this.moduleInfo.Has("name") || !this.moduleInfo["name"]) {
            this.moduleInfo["name"] := this.Key
        }

        if (!this.moduleInfo.Has("version") || !this.moduleInfo["version"] || this.moduleInfo["version"] == "{{VERSION}}") {
            this.moduleInfo["version"] := AppBase.Instance ? AppBase.Instance.Version : ""
        }
    }

    __Enum(numberOfVars) {
        return this.moduleInfo.__Enum(numberOfVars)
    }

    SetModuleInfo(moduleInfo) {
        this.moduleInfo := moduleInfo
    }

    Get(key := "") {
        return this.moduleInfo[key]
    }

    Set(key, value) {
        this.moduleInfo[key] := value
    }

    Has(key) {
        return this.moduleInfo.Has(key)
    }

    Delete(key) {
        this.moduleInfo.Delete(key)
    }
}
