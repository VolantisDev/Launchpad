class ApiDataSource extends DataSourceBase {
    endpointUrl := ""

    __New(app, cache, endpointUrl) {
        InvalidParameterException.CheckTypes("ApiDataSource", "endpointUrl", endpointUrl, "")
        InvalidParameterException.CheckEmpty("ApiDataSource", "cache", cache)
        this.endpointUrl := endpointUrl
        super.__New(app, cache)
    }

    ItemExists(path) {
        return super.ItemExists(path) || this.ItemExistsInApi(path)
    }

    ItemExistsInApi(path) {
        request := WinHttpReq.new(this.GetRemoteLocation(path))
        result := request.Send("HEAD")
        response := (result == -1 && request.GetStatusCode() == 200)
        return response
    }

    GetRemoteLocation(path) {
        return this.endpointUrl . "/" . path
    }

    RetrieveItem(path) {
        return this.ItemExistsInApi(path) ? this.cache.ImportItemFromUrl(path, this.GetRemoteLocation(path)) : ""
    }

    Open() {
        Run(this.endpointUrl)
    }

    ChangeApiEndpoint(existingEndpoint := "", owner := "MainWindow", parent := "") {
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
