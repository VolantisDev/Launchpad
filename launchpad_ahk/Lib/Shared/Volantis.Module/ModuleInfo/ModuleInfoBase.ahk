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

        if (!this.moduleInfo.Has("category") || !this.moduleInfo["category"]) {
            this.moduleInfo["category"] := "General"
        }

        if (!this.moduleInfo.Has("tags") || !this.moduleInfo["tags"]) {
            this.moduleInfo["tags"] := ["Launchpad"]
        }

        if (!HasBase(this.moduleInfo["tags"], Array.Prototype)) {
            this.moduleInfo["tags"] := [this.moduleInfo["tags"]]
        }

        if (!this.moduleInfo.Has("dependencies") || !this.moduleInfo["dependencies"]) {
            this.moduleInfo["dependencies"] := []
        }

        if (!this.moduleInfo.Has("appVersion") || !this.moduleInfo["appVersion"] || this.moduleInfo["appVersion"] == "{{VERSION}}") {
            this.moduleInfo["appVersion"] := AppBase.Instance ? AppBase.Instance.Version : ""
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
