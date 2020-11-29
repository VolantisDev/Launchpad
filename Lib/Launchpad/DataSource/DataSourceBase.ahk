class DataSourceBase {
    app := ""
    cache := ""
    useCache := false
    maxCacheAge := 86400

    __New(app, cache := "") {
        InvalidParameterException.CheckTypes("ValidateLaunchersOp", "app", app, "Launchpad")

        this.app := app

        if (cache != "") {
            InvalidParameterException.CheckTypes("ValidateLaunchersOp", "cache", cache, "CacheBase")

            this.useCache := true
            this.cache := cache
        }
    }

    ItemExists(path) {
        return this.useCache ? this.cache.ItemExists(path) : false
    }

    ReadItem(path) {
        if (this.ItemNeedsRetrieval(path)) {
            this.RetrieveItem(path)
        }

        return this.useCache ? this.cache.ReadItem(path) : ""
    }

    ItemNeedsRetrieval(path) {
        return (!this.useCache || this.cache.ItemNeedsUpdate(path))
    }

    RetrieveItem(path) {
        return ""
    }

    CopyItem(path, destination) {
        if (this.ItemNeedsRetrieval(path)) {
            this.RetrieveItem(path)
        }

        return this.useCache ? this.cache.CopyItem(path, destination) : destination
    }

    GetRemoteLocation(path) {
        
    }

    ReadListing(path) {
        listingInstance := DSListing.new(this.app, path, this)

        listingItems := Map()

        if (listingInstance.Exists()) {
            listing := listingInstance.Read()
            listingItems := listing["items"]
        }

        return listingItems
    }

    ReadJson(key, path := "") {
        dsItem := DSJson.new(this.app, key, path, this)
        return dsItem.Read()
    }
}
