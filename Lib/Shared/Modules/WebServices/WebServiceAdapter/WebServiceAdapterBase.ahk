class WebServiceAdapterBase {
    container := ""
    webService := ""
    definition := ""
    dataClass := ""
    merger := ""
    operationTypes := ["create", "read", "update", "delete"]

    static ADAPTER_RESULT_DATA := "data"
    static ADAPTER_RESULT_HTTP_STATUS := "httpStatus"
    static ADAPTER_RESULT_SUCCESS := "success"
    
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
            "dataMap", Map(),
            "dataSelector", "",
            "weight", 0,
            "entityType", "",
            "tags", [],
            "requiredParams", [],
        )
    }

    SupportsOperation(operation) {
        supported := false

        for index, operationType in this.operationTypes {
            if (operation == operationType) {
                supported := true

                break
            }
        }

        return supported
    }

    SendRequest(operation, params := "") {
        if (!this.SupportsOperation(operation)) {
            throw AppException("The '" . operation . "' operation is not supported by this data adapter.")
        }

        result := ""
        data := params.Has("data") ? params["data"] : ""

        if (operation == "create") {
            result := this.CreateData(data, params)
        } else if (operation == "read") {
            result := this.ReadData(params)
        } else if (operation == "update") {
            result := this.UpdateData(data, params)
        } else if (operation == "delete") {
            result := this.DeleteData(params)
        }

        return result
    }

    CreateData(data, params := "") {
        if (!this.definition["createAllow"]) {
            throw AppException("The 'create' operation is not allowed on this data adapter.")
        }

        response := this._request(
            params,
            this.definition["createMethod"],
            data ? data : this._getData(params),
            this.definition["createAuth"],
            false
        ).Send()

        return this._getResult(
            params,
            response,
            this._getResultType(params, WebServiceAdapterBase.ADAPTER_RESULT_SUCCESS)
        )
    }

    _getResultType(params, default) {
        resultType := default

        if (params.Has("resultType") && params["resultType"]) {
            resultType := params["resultType"]
        }

        return resultType
    }

    _getResult(params, response, resultType) {
        result := ""

        if (resultType == WebServiceAdapterBase.ADAPTER_RESULT_DATA) {
            if (response.IsSuccessful()) {
                data := response.GetResponseBody()

                if (data) {
                    result := this._mapData(this._parseData(data, params), params)
                }
                
            }
        } else if (resultType == WebServiceAdapterBase.ADAPTER_RESULT_HTTP_STATUS) {
            result := response.GetHttpStatusCode()
        } else if (resultType == WebServiceAdapterBase.ADAPTER_RESULT_SUCCESS) {
            result := response.IsSuccessful()
        }

        return result
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

        return this._getResult(
            params,
            response,
            this._getResultType(params, WebServiceAdapterBase.ADAPTER_RESULT_DATA)
        )
    }

    UpdateData(data, params := "") {
        if (!this.definition["updateAllow"]) {
            throw AppException("The 'update' operation is not allowed on this data adapter.")
        }

        response := this._request(
            params,
            this.definition["updateMethod"],
            data ? data : this._getData(params),
            this.definition["updateAuth"],
            false
        ).Send()

        return this._getResult(
            params,
            response,
            this._getResultType(params, WebServiceAdapterBase.ADAPTER_RESULT_SUCCESS)
        )
    }

    DeleteData(params := "") {
        if (!this.definition["deleteAllow"]) {
            throw AppException("The 'delete' operation is not allowed on this data adapter.")
        }

        response := this._request(
            params,
            this.definition["deleteMethod"],
            this._getData(params),
            this.definition["deleteAuth"],
            false
        ).Send()

        return this._getResult(
            params,
            response,
            this._getResultType(params, WebServiceAdapterBase.ADAPTER_RESULT_SUCCESS)
        )
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

    _validateParams(params) {
        if (!params) {
            params := Map()
        }

        valid := true
        requiredParams := this.definition["requiredParams"]

        if (requiredParams) {
            if (Type(requiredParams) == "String") {
                requiredParams := [requiredParams]
            }
    
            for , requiredParam in requiredParams {
                if (!params.Has(requiredParam) || !params[requiredParam]) {
                    valid := false
    
                    break
                }
            }
        }

        return valid
    }

    _request(params, method, data, useAuthentication, cacheResponse) {
        if (!this._validateParams(params)) {
            throw AppException("The data adapter request was called with invalid or missing parameters.")
        }

        requestPath := this.definition["requestPath"]

        for key, value in params {

        }

        return this.webService.Request(
            this._requestPath(params), 
            method, 
            data,
            useAuthentication, 
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
        if (data && this.dataClass) {
            dataClass := this.dataClass
            data := %dataClass%().FromString(&data)

            if (this.definition["dataSelector"]) {
                dataSelector := this.definition["dataSelector"]

                if (Type(dataSelector) == "String") {
                    dataSelector := StrSplit(dataSelector, ".")
                }

                for index, pathPart in dataSelector {
                    if (data.Has(pathPart)) {
                        data := data[pathPart]
                    } else {
                        data := ""
                        break
                    }
                }
            }
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
