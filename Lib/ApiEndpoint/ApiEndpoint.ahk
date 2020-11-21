class ApiEndpoint {
    app := ""
    cache := ""
    endpointUrl := ""

    __New(app, endpointUrl, cache) {
        this.app := app
        this.endpointUrl := endpointUrl
        this.cache := cache
    }

    GetApiUrl(path) {
        return this.endpointUrl . "/" . path
    }

    ItemExistsInApi(path) {
        request := HttpReq.new(this.GetApiUrl(path))
        result := request.Send("HEAD")
        return (result == -1 && request.GetStatusCode() == 200)
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
}
