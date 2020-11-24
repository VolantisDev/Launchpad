class JsonConfig extends FileConfig {
    config := Map()
    primaryConfigKey := "Config"

    __New(app, configPath := "", autoLoad := true) {
        super.__New(app, configPath, ".json", autoLoad)
    }

    LoadConfig(configPath := "") {
        if (configPath == "") {
            configPath := this.configPath
        }

        if (configPath == "") {
            this.app.Notifications.Error("Config file path not provided.")
            return this
        }

        jsonString := FileRead(configPath)
        this.config := (jsonString != "") ? Jxon_Load(jsonString) : Map()
        return super.LoadConfig(configPath)
    }

    SaveConfig(configPath := "") {
        if (configPath == "") {
            configPath := this.configPath
        }

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
        
        FileAppend(Jxon_Dump(this.config, "", 4), configPath)
        return super.SaveConfig(configPath)
    }

    CountItems() {
        count := 0
        
        for key, value in this.config[this.primaryConfigKey] {
            count++
        }

        return count
    }
}
