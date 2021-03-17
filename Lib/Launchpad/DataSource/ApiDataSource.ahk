class ApiDataSource extends DataSourceBase {
    endpointUrl := ""
    app := ""

    __New(app, cache, endpointUrl) {
        this.app := app
        InvalidParameterException.CheckTypes("ApiDataSource", "endpointUrl", endpointUrl, "")
        InvalidParameterException.CheckEmpty("ApiDataSource", "cache", cache)
        this.endpointUrl := endpointUrl
        super.__New(cache)
    }

    ItemExists(path) {
        return super.ItemExists(path) || this.ItemExistsInApi(path)
    }

    ItemExistsInApi(path) {
        exists := (this.cache.ItemExists(path) && !this.cache.ItemNeedsUpdate(path))

        if (!exists) {
            request := this.SendHttpReq(path, "HEAD")
            
            response := (request.GetReturnCode() == -1 && request.GetStatusCode() == 200)

            if (!response) {
                this.cache.SetNotFound(path)
            }
        }

        return response
    }

    GetHttpReq(path) {
        request := WinHttpReq.new(this.GetRemoteLocation(path))

        if (this.app.Config.ApiToken) {
            request.requestHeaders["Bearer"] := this.app.Config.ApiToken
        }

        return request
    }

    SendHttpReq(path, method := "GET", data := "") {
        request := this.GetHttpReq(path)
        returnCode := request.Send(method, data)
        return request
    }

    GetRemoteLocation(path) {
        return this.endpointUrl . "/" . path
    }

    RetrieveItem(path) {
        exists := (this.cache.ItemExists(path) && !this.cache.ItemNeedsUpdate(path))

        if (!exists) {
            request := this.SendHttpReq(path)

            if (request.GetReturnCode() != -1) {
                return ""
            }

            responseBody := Trim(request.GetResponseData())

            if (responseBody == "") {
                return ""
            }

            this.cache.WriteItem(path, responseBody)
        }

        return this.cache.ItemExists(path) ? this.cache.ReadItem(path) : ""
    }

    GetStatus() {
        path := "status"
        statusExpire := 21600
        if (this.cache.ItemExists(path) && this.cache.GetCacheAge(path) >= statusExpire) {
            this.cache.RemoveItem(path)
        }

        status := this.ReadItem(path)

        if (status) {
            json := JsonData.new()
            status := json.FromString(status)
        } else {
            status := Map("authenticated", true, "email", "")
        }

        return status
    }

    Open() {
        Run(this.endpointUrl)
    }

    ChangeApiEndpoint(existingEndpoint := "", owner := "ManageWindow", parent := "") {
        if (existingEndpoint == "") {
            existingEndpoint := this.app.Config.ApiEndpoint
        }

        text := "Enter the base URL of the API endpoint you would like Launchpad to connect to. Leave blank to revert to the default."
        apiEndpointUrl := this.app.Windows.SingleInputBox("API Endpoint URL", text, existingEndpoint, owner, parent)

        if (apiEndpointUrl != existingEndpoint) {
            this.app.Config.ApiEndpoint := apiEndpointUrl
            apiEndpointUrl := this.app.Config.ApiEndpoint

            if (apiEndpointUrl != existingEndpoint) {
                this.endpointUrl := apiEndpointUrl
                this.cache.FlushCache()
            }
        }
        
        return apiEndpointUrl
    }
}
