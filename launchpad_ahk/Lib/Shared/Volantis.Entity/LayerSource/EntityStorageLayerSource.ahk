class EntityStorageLayerSource extends LayerSourceBase {
    storageObj := ""
    storageId := ""

    __New(storageObj, storageId) {
        this.storageObj := storageObj
        this.storageId := storageId
    }
    
    SaveData(data := "") {
        this.storageObj.SaveData(this.storageId, data)
        return this
    }

    LoadData() {
        return this.storageObj.LoadData(this.storageId)
    }

    HasData() {
        return this.storageObj.HasData(this.storageId)
    }

    DeleteData() {
        if (this.HasData()) {
            this.storageObj.DeleteData(this.storageId)
        }

        return this
    }
}
