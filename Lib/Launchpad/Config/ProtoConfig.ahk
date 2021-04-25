class ProtoConfig extends FileConfig {
    config := Map()
    primaryConfigKey := "Database"
    protoFile := ""
    configKey := "ProtoConfig"

    __New(app, configPath, protoFile, autoLoad := true) {
        this.protoFile := protoFile
        super.__New(app, configPath, "", autoLoad)
    }

    LoadConfigFile(configPath) {
        data := ProtobufData()
        this.config := data.FromFile(this.configPath, this.primaryConfigKey, this.protoFile)
    }

    SaveConfig() {
        this.app.Service("NotificationService").Error("Protobuf file saving is not yet implemented.")
        return this
    }

    CountItems() {
        count := 0
        
        for key, value in this.config {
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
