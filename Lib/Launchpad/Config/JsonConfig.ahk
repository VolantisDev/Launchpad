class JsonConfig extends FileConfig {
    config := Map()
    primaryConfigKey := "Config"

    __New(app, configPath := "", autoLoad := true) {
        super.__New(app, configPath, ".json", autoLoad)
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
        
        for key, value in this.config[this.primaryConfigKey] {
            count++
        }

        return count
    }

    ; Performs a deep clone of the JSON map
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
