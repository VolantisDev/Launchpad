#Include FileConfig.ahk

class JsonConfig extends FileConfig {
    config := Map()
    primaryConfigKey := "Config"

    __New(app, configPath := "", autoLoad := true) {
        super.__New(app, configPath, ".json", autoLoad)
    }

    LoadConfig() {
        if (this.ConfigPath == "") {
            this.app.Toast("Config file path not provided.", "Launchpad", 10, 3)
            return this
        }

        jsonString := FileRead(this.ConfigPath)

        if (jsonString != "") {
            this.config := JSON.Load(jsonString)
        } else {
            this.config := Map()
        }

        return this
    }

    SaveConfig() {
        if (this.ConfigPath == "") {
            this.AskForPath()
        }

        if (this.ConfigPath == "") {
            this.app.Toast("Config file path not provided.", "Launchpad", 10, 3)
            return this
        }

        if (FileExist(this.ConfigPath)) {
            FileDelete(this.ConfigPath)
        }
        
        jsonString := JSON.Dump(this.config, "", 4)
        FileAppend(jsonString, this.ConfigPath)

        return this
    }

    CountItems() {
        count := 0
        for (key, value in this.config[this.primaryConfigKey]) {
            count++
        }
        return count
    }
}
