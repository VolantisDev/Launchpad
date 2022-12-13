class WebServiceAdapterBase {
    container := ""
    webService := ""
    definition := ""
    dataType := ""
    merger := ""
    
    __New(container, merger, webService, definition) {
        this.container := container
        this.merger := merger
        this.webService := webService

        if (!definition) {
            definition := Map()
        }

        if (!HasBase(definition, Map.Prototype)) {
            throw AppException("Definition must be a Map-like object.")
        }

        this.definition := this.merger.Merge(this.GetDefaultDefinition(), definition)
    }

    static Create(container, webService, definition) {
        className := this.Prototype.__Class

        return %className%(
            container,
            container.Get("merger.list"),
            webService,
            definition
        )
    }

    GetDefaultDefinition() {
        return Map(
            "dataType", "",
            "adapterType", "json",
            "requestPath", "",
            "requestData", "",
            "cacheResponse", true,
            "cacheMaxAge", 186400,
            "createAllow", false,
            "createMethod", "POST",
            "createAuth", true,
            "readAllow", true,
            "readMethod", "GET",
            "readAuth", false,
            "updateAllow", false,
            "updateMethod", "POST",
            "updateAuth", true,
            "deleteAllow", false,
            "deleteMethod", "PUT",
            "deleteAuth", true,
            "dataMap", Map()
        )
    }

    CreateData(data, params := "") {
        if (!this.definition["createAllow"]) {
            throw AppException("The 'create' operation is not allowed on this data adapter.")
        }

        return this._request(
            params,
            this.definition["createMethod"],
            data ? data : this._getData(params),
            this.definition["createAuth"],
            false
        ).Send().IsSuccessful()
    }

    DataExists(params := "") {
        if (!this.definition["readAllow"]) {
            throw AppException("The 'read' operation is not allowed on this data adapter.")
        }

        return this._request(
            params,
            this.definition["readMethod"],
            this._getData(params),
            this.definition["readAuth"],
            false
        ).Send().IsSuccessful()
    }

    ReadData(params := "") {
        if (!this.definition["readAllow"]) {
            throw AppException("The 'read' operation is not allowed on this data adapter.")
        }

        response := this._request(
            params,
            this.definition["readMethod"],
            this._getData(params),
            this.definition["readAuth"],
            this.definition["cacheResponse"]
        ).Send()

        data := ""

        if (response.IsSuccessful()) {
            data := response.GetResponseBody()
            data := this._parseData(data, params)
            this._mapData(data, params)
        }

        return data
    }

    UpdateData(data, params := "") {
        if (!this.definition["updateAllow"]) {
            throw AppException("The 'update' operation is not allowed on this data adapter.")
        }

        return this._request(
            params,
            this.definition["updateMethod"],
            data ? data : this._getData(params),
            this.definition["updateAuth"],
            false
        ).Send().IsSuccessful()
    }

    DeleteData(params := "") {
        if (!this.definition["deleteAllow"]) {
            throw AppException("The 'delete' operation is not allowed on this data adapter.")
        }

        return this._request(
            params,
            this.definition["deleteMethod"],
            this._getData(params),
            this.definition["deleteAuth"],
            false
        ).Send().IsSuccessful()
    }

    _requestPath(params) {
        requestPath := this.definition["requestPath"]
        isFound := true

        while isFound {
            match := ""
            isFound := RegExMatch(requestPath, "({([^}]+)})", &match)

            if (isFound) {
                key := match[2]

                replacement := (params && params.Has(key))
                    ? params[key]
                    : ""

                requestPath := StrReplace(requestPath, match[1], replacement)
            }
        }

        return requestPath
    }

    _request(params, method, data, cacheResponse) {
        return this.webService.Request(
            this.definition["requestPath"], 
            method, 
            data,
            this.definition["useAuthentication"], 
            cacheResponse
        )
    }

    _mapData(data, params, reverse := false) {
        if (
            data
            && HasBase(data, Map.Prototype) 
            && this.definition["dataMap"] 
            && HasBase(this.definition["dataMap"], Map.Prototype)
        ) {
            for key1, key2 in this.definition["dataMap"] {
                oldKey := reverse ? key2 : key1
                newKey := reverse ? key1 : key2

                if (data.Has(oldKey)) {
                    data[newKey] := data[oldKey]
                    data.Delete(oldKey)
                }
            }
        }
    }

    _parseData(data, params) {
        if (data && this.dataType) {
            dataType := this.dataType
            data := %dataType%().FromString(data)
        }

        return data
    }

    _getData(params, data := "") {
        if (!data) {
            if (params.Has("data") && params["data"]) {
                data := params["data"]
            } else if (this.definition["requestData"]) {
                data := this.definition["requestData"]
            }
        }
        
        return data
    }
}
