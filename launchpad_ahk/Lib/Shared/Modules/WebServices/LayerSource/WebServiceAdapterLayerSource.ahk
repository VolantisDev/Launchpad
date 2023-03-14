class WebServiceAdapterLayerSource extends LayerSourceBase {
    adapter := ""
    params := ""
    
    __New(adapter, params := "") {
        if (!params)  {
            params := Map()
        }

        this.adapter := adapter
        this.params := params
    }

    SaveData(data := "") {
        if (this.HasData()) {
            if (this.adapter.definition["updateAllow"]) {
                this.adapter.UpdateData(data, this.params)
            }
        } else if (this.adapter.definition["createAllow"]) {
            this.adapter.CreateData(data, this.params)
        }

        return this
    }

    LoadData() {
        data := ""

        if (this.adapter.definition["readAllow"]) {
            data := this.adapter.ReadData(this.params)
        }
        
        if (!data) {
            data := Map()
        }

        return data
    }

    HasData() {
        return this.adapter.DataExists(this.params)
    }

    DeleteData() {
        if (this.adapter.definitions["deleteAllow"]) {
            this.adapter.DeleteData(this.params)
        }

        return this
    }
}
