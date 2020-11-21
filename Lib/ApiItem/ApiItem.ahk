class ApiItem {
    app := ""
    endpoint := ""
    basePath := ""
    itemSuffix := ""
    path := ""
    key := ""
    maxCacheAge := 86400

    __New(app, key, path := "") {
        this.app := app
        this.endpoint := app.ApiEndpoint
        this.key := key
        this.path := path
    }

    GetFilename() {
        return this.key . this.itemSuffix
    }

    GetPath(includeFilename := true) {
        path := this.basePath

        if (path != "" && this.path != "") {
            path .= "/"
        }

        path .= this.path

        if (includeFilename) {
            path .= "/" . this.GetFilename()
        }

        return path
    }

    GetCachePath() {
        return this.endpoint.cache.GetCachePath(this.GetPath())
    }

    GetCacheAge() {
        return this.endpoint.cache.GetCacheAge(this.GetPath())
    }

    GetApiUrl() {
        return this.endpoint.GetApiUrl(this.GetPath())
    }

    Exists() {
        return this.endpoint.ItemExists(this.GetPath())
    }

    Read() {
        return this.endpoint.ReadItem(this.GetPath(), this.maxCacheAge)
    }

    Copy(destination) {
        return this.endpoint.CopyItem(this.GetPath(), destination, this.maxCacheAge)
    }
}
