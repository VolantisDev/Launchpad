class JsonConfigStorage extends ConfigStorageBase {
    primaryConfigKey := ""

    __New(storagePath, primaryConfigKey := "config") {
        this.primaryConfigKey := primaryConfigKey
        super.__New(storagePath)
    }

    ReadConfig(ignoreNotFound := true) {
        config := Map()

        if (FileExist(this.storagePath)) {
            json := JsonData()
            config := json.FromFile(this.storagePath)

            if (!config) {
                throw ConfigException("Json file " . this.storagePath . " could not be loaded")
            }

            if (this.primaryConfigKey) {
                if (!config.Has(this.primaryConfigKey)) {
                    throw ConfigException("Json file " . this.storagePath . " does not contain primary key " . this.primaryConfigKey)
                }

                config := config[this.primaryConfigKey]
            }
        } else if (!ignoreNotFound) {
            throw ConfigException("Config file " . this.storagePath . " does not exist")
        }

        return config
    }

    WriteConfig(configMap, overwrite := false) {
        if (this.primaryConfigKey) {
            configMap := Map(this.primaryConfigKey, configMap)
        }

        json := JsonData(configMap)
        json.ToFile(this.storagePath, overwrite, 4)
        return this.storagePath
    }
}
