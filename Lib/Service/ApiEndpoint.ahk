class ApiEndpoint extends ServiceBase {
    cache := ""
    endpointUrl := ""

    __New(app, endpointUrl, cache) {
        this.endpointUrl := endpointUrl
        this.cache := cache
        super.__New(app)
    }

    GetApiUrl(path) {
        return this.endpointUrl . "/" . path
    }

    ItemExistsInApi(path) {
        request := HttpReq.new(this.GetApiUrl(path))
        result := request.Send("HEAD")
        response := (result == -1 && request.GetStatusCode() == 200)
        return response
    }

    ItemExists(path) {
        exists := this.cache.ItemExists(path)

        if (!exists) {
            exists := this.ItemExistsInApi(path)
        }

        return exists
    }

    DownloadItem(path) {
        filePath := ""

        if (this.ItemExistsInApi(path)) {
            filePath := this.cache.ImportItemFromUrl(path, this.getApiUrl(path))
        }

        return filePath
    }

    ReadItem(path, maxCacheAge := 86400) {
        if (this.cache.ItemNeedsUpdate(path, maxCacheAge)) {
            this.DownloadItem(path)
        }

        return this.cache.ReadItem(path)
    }

    CopyItem(path, destination, maxCacheAge := 86400) {
        if (this.cache.ItemNeedsUpdate(path, maxCacheAge)) {
            this.DownloadItem(path)
        }

        return this.cache.CopyItem(path, destination)
    }

    OpenApiEndpoint() {
        Run(this.endpointUrl)
    }

    ChangeApiEndpoint(existingEndpoint := "", owner := "MainWindow") {
        if (existingEndpoint == "") {
            existingEndpoint := this.app.AppConfig.ApiEndpoint
        }

        text := "Enter the base URL of the API endpoint you would like Launchpad to connect to. Leave blank to revert to the default."
        apiEndpointUrl := this.GuiManager.SingleInputBox("API Endpoint URL", text, existingEndpoint, owner)

        if (apiEndpointUrl != existingEndpoint) {
            this.app.AppConfig.ApiEndpoint := apiEndpointUrl
            apiEndpointUrl := this.app.AppConfig.ApiEndpoint

            if (apiEndpointUrl != existingEndpoint) {
                this.endpointUrl := apiEndpointUrl
                this.cache.FlushCache()
            }
        }
        
        return apiEndpointUrl
    }
}
