class WebServiceLayerSource extends LayerSourceBase {
    webService := ""
    path := ""
    useAuthentication := false

    ; A map in the format oldKey => newKey
    fieldMap := Map()
    
    __New(webService, path, useAuthentication := false) {
        this.webService := webService
        this.path := path
        this.useAuthentication := useAuthentication
    }

    SaveData(data := "") {
        ; Web services don't supoport saving layer data yet.
        return this
    }

    LoadData() {
        request := this.webService.Request(this.path, "GET", "", this.useAuthentication, true)
        response := request.Send()
        responseBody := response.GetResponseBody()

        data := ""

        if (responseBody) {
            data := JsonData().FromString(&responseBody)
        } else {
            data := Map()
        }

        for oldKey, newKey in this.fieldMap {
            if data.Has(oldKey) {
                data[newKey] := data[oldKey]
                data.Delete(oldKey)
            }
        }

        return data
    }

    HasData() {
        request := this.webService.Request(this.path, "HEAD", "", this.useAuthentication, false)
        response := request.Send()
        exists := response.GetHttpStatusCode()

        if (!exists) {
            request.cacheObj.SetNotFound(this.path)
        }

        return exists
    }

    DeleteData() {
        ; Web services don't support deleting layer data yet.
        return this
    }
}
