class JsonConfig extends FileConfig {
    config := Map()
    primaryConfigKey := "Config"

    __New(app, configPath := "", autoLoad := true) {
        super.__New(app, configPath, ".json", autoLoad)
    }

    LoadConfig() {
        configPath := this.configPath

        if (configPath == "") {
            this.app.Notifications.Error("Config file path not provided.")
            return this
        }

        if (FileExist(configPath)) {
            data := JsonData.new()
            this.config := data.FromFile(configPath)
        } else {
            this.config := Map()
        }

        return super.LoadConfig()
    }

    SaveConfig() {
        configPath := this.ConfigPath

        if (configPath == "") {
            this.AskForPath()
        }

        if (configPath == "") {
            this.app.Notifications.Error("Config file path not provided.")
            return this
        }

        if (FileExist(configPath)) {
            FileDelete(configPath)
        }

        

        data := JsonData.new(this.config)
        data.ToFile(configPath, "", 4)
        return super.SaveConfig()
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
