class CacheManager extends AppComponentServiceBase {
    _registerEvent := "" ;Events.CACHES_REGISTER
    _alterEvent := "" ;Events.CACHES_ALTER
    cacheDir := ""

    __New(app, cacheDir, components := "") {
        InvalidParameterException.CheckTypes("CacheManager", "cacheDir", cacheDir, "")
        InvalidParameterException.CheckEmpty("CacheManager", "cacheDir", cacheDir)
        this.cacheDir := cacheDir
        
        super.__New(app, components)
    }

    LoadComponents() {
        if (!this._componentsLoaded) {
            this.SetItem("file", FileCache.new(CacheState.new(this.app, this.cacheDir . "\File.json"), this.cacheDir . "\File"))
            this.SetItem("api", FileCache.new(CacheState.new(this.app, this.cacheDir . "\API.json"), this.cacheDir . "\API"))
        }

        super.LoadComponents()
    }

    SetCacheDir(cacheDir) {
        this.app.Config.CacheDir := cacheDir
        this.cacheDir := this.app.Config.CacheDir
    }

    FlushCaches(notify := true) {
        for key, cacheObj in this._components
        {
            this.FlushCache(key, false)
        }

        if (notify) {
            this.app.Notifications.Info("Flushed all caches.")
        }
    }

    FlushCache(key, notify := false) {
        if (this._components.Has(key)) {
            this._components[key].FlushCache()

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
