class DataSourceBase {
    cache := ""
    useCache := false
    maxCacheAge := 86400

    __New(cacheManager := "", cacheName := "") {
        if (cacheManager != "" && cacheName != "") {
            InvalidParameterException.CheckTypes("DataSourceBase", "cacheManager", cacheManager, "CacheManager")
            this.useCache := true
            this.cache := cacheManager.GetItem(cacheName)
        }
    }

    ItemExists(path) {
        return this.useCache ? this.cache.ItemExists(path) : false
    }

    ReadItem(path, private := false, maxCacheAge := "") {
        if (maxCacheAge == "") {
            maxCacheAge := this.maxCacheAge
        }

        item := ""

        if (this.ItemNeedsRetrieval(path)) {
            item := this.RetrieveItem(path, private, maxCacheAge)
        } else if (this.useCache) {
            item := this.cache.ReadItem(path)
        }

        return item
    }

    ItemNeedsRetrieval(path) {
        return (!this.useCache || this.cache.ItemNeedsUpdate(path))
    }

    RetrieveItem(path, private := false, maxCacheAge := "") {
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
        listingInstance := DSListing(path, this)

        listing := []

        if (listingInstance.Exists()) {
            listing := listingInstance.Read()
        }

        return listing
    }

    ReadJson(key, path := "") {
        dsItem := DSJson(key, path, this)
        return dsItem.Read()
    }
}
