class JsonConfig extends FileConfig {
    config := Map()
    primaryConfigKey := "Config"

    __New(app, configPath := "", autoLoad := true) {
        super.__New(app, configPath, ".json", autoLoad)
    }

    LoadConfig() {
        result := super.LoadConfig()

        if (this.primaryConfigKey && !this.config.Has(this.primaryConfigKey)) {
            this.config[this.primaryConfigKey] := Map()
        }

        return result
    }

    LoadConfigFile(configPath) {
        data := JsonData.new()
        this.config := data.FromFile(configPath)
    }

    SaveConfigFile(configPath) {
        data := JsonData.new(this.config)
        data.ToFile(configPath, "", 4)
    }

    CountItems() {
        count := 0

        if (this.config.Has(this.primaryConfigKey)) {
            for key, value in this.config[this.primaryConfigKey] {
                count++
            }
        }

        return count
    }

    Clone() {
        newEntity := super.Clone()
        newEntity.config := this.config.Clone()
        newEntity := this.CloneChildMaps(newEntity)
    }

    CloneChildMaps(parentMap) {
        for key, child in parentMap {
            if (Type(child) == "Map") {
                parentMap[key] := this.CloneChildMaps(child)
            }
        }

        return parentMap
    }
}
