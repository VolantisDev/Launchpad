class ApiDataSource extends DataSourceBase {
    endpointUrl := ""
    app := ""

    __New(app, cacheManager, cacheName, endpointUrl) {
        this.app := app
        InvalidParameterException.CheckTypes("ApiDataSource", "endpointUrl", endpointUrl, "", "cacheManager", cacheManager, "CacheManager")
        this.endpointUrl := endpointUrl
        super.__New(cacheManager, cacheName)
    }

    ItemExists(path) {
        return super.ItemExists(path) || this.ItemExistsInApi(path)
    }

    ItemExistsInApi(path) {
        exists := (this.cache.ItemExists(path) && !this.cache.ItemNeedsUpdate(path))

        if (!exists) {
            request := this.SendHttpReq(path, "HEAD")
            
            response := (request.GetStatusCode() == 200)

            if (!response) {
                this.cache.SetNotFound(path)
            }
        }

        return response
    }

    GetHttpReq(path, private := false) {
        request := WinHttpReq(this.GetRemoteLocation(path))

        if (private) {
            request.requestHeaders["Cache-Control"] := "no-cache"

            if (this.app.Config["api_authentication"]) {
                this.app.Service("Auth").AlterApiRequest(request)
            }
        }

        return request
    }

    SendHttpReq(path, method := "GET", data := "", private := false) {
        request := this.GetHttpReq(path, private)
        returnCode := request.Send(method, data)
        return request
    }

    GetRemoteLocation(path) {
        return this.endpointUrl . "/" . path
    }

    RetrieveItem(path, private := false, maxCacheAge := "") {
        if (maxCacheAge == "") {
            maxCacheAge := this.maxCacheAge
        }

        exists := (!private && this.cache.ItemExists(path) && !this.cache.ItemNeedsUpdate(path, maxCacheAge))

        if (!exists) {
            request := this.SendHttpReq(path, "GET", "", private)

            if (request.GetStatusCode() != 200) {
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
        statusExpire := 5 ;60

        status := Map("authenticated", false, "email", "", "photo", "")

        if (this.app.Config["api_authentication"] && this.app.Service("Auth").IsAuthenticated()) {
            statusResult := this.ReadItem(path, true)

            if (statusResult) {
                json := JsonData()
                status := json.FromString(&statusResult)
            }
        }

        return status
    }

    GetExt(path) {

    }

    Open() {
        Run(this.endpointUrl)
    }

    ChangeApiEndpoint(existingEndpoint := "", owner := "", parent := "") {
        if (existingEndpoint == "") {
            existingEndpoint := this.app.Config["api_endpoint"]
        }

        text := "Enter the base URL of the API endpoint you would like Launchpad to connect to. Leave blank to revert to the default."
        apiEndpointUrl := this.app.Service("GuiManager").Dialog("SingleInputBox", "API Endpoint URL", text, existingEndpoint, owner, parent)

        if (apiEndpointUrl != existingEndpoint) {
            this.app.Config["api_endpoint"] := apiEndpointUrl
            apiEndpointUrl := this.app.Config["api_endpoint"]

            if (apiEndpointUrl != existingEndpoint) {
                this.endpointUrl := apiEndpointUrl
                this.cache.FlushCache()
            }
        }
        
        return apiEndpointUrl
    }
}
