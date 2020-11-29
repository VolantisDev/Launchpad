class CacheManager extends ServiceBase {
    cacheDir := ""
    caches := Map()

    __New(app, cacheDir) {
        InvalidParameterException.CheckTypes("CacheManager", "cacheDir", cacheDir, "")
        InvalidParameterException.CheckEmpty("CacheManager", "cacheDir", cacheDir)
        this.cacheDir := cacheDir
        super.__New(app)
        this.SetupCaches()
    }

    SetupCaches() {
        this.caches["app"] := ObjectCache.new()
        this.caches["file"] := FileCache.new(this.cacheDir)
        this.caches["api"] := FileCache.new(this.cacheDir . "\API")
    }

    SetCacheDir(cacheDir) {
        this.app.Config.CacheDir := cacheDir
        this.cacheDir := this.app.Config.CacheDir
    }

    GetCache(key) {
        return (this.caches.Has(key)) ? this.caches[key] : ""
    }

    SetCache(key, cacheObj) {
        this.caches[key] := cacheObj
    }

    FlushCaches(notify := true) {
        for key, cacheObj in this.caches
        {
            this.FlushCache(key, false)
        }

        if (notify) {
            this.app.Notifications.Info("Flushed all caches.")
        }
    }

    FlushCache(key, notify := false) {
        if (this.caches.Has(key)) {
            this.caches[key].FlushCache()

            if (notify) {
                this.app.Notifications.Info("Flushed cache: " . key . ".")
            }
        }
    }

    ChangeCacheDir() {
        cacheDir := DirSelect("*" . this.app.Config.CacheDir, 3, "Create or select the folder to save Launchpad's cache files to")
        
        if (cacheDir != "") {
            this.SetCacheDir(cacheDir)
            this.FlushCaches()
            this.SetupCaches()
        }

        return cacheDir
    }

    OpenCacheDir() {
        Run(this.cacheDir)
    }
}
