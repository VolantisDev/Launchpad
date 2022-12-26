class MapLayerSource extends LayerSourceBase {
    mapObj := ""
    cloner := ""
    cloneData := false
    
    __New(cloner, mapObj, cloneData := true) {
        this.mapObj := mapObj
        this.cloner := cloner
        this.cloneData := cloneData
    }
    
    SaveData(data := "") {
        if (!data) {
            data := Map()
        } else if (this.cloneData) {
            data := this.cloner.Clone(data)
        }

        this.mapObj := data

        return this
    }

    LoadData() {
        data := this.mapObj

        if (this.HasData() && this.cloneData) {
            data := this.cloner.Clone(data)
        }

        return data
    }

    HasData() {
        return !!(this.mapObj)
    }

    DeleteData() {
        if (this.HasData()) {
            this.mapObj := ""
        }
    }
}
