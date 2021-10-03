class CacheManager extends AppComponentServiceBase {
    _registerEvent := Events.CACHES_REGISTER
    _alterEvent := Events.CACHES_ALTER
    cacheDir := ""

    __New(app, cacheDir, components := "") {
        InvalidParameterException.CheckTypes(
            "CacheManager", 
            "cacheDir", cacheDir, ""
        )

        InvalidParameterException.CheckEmpty(
            "CacheManager", 
            "cacheDir", cacheDir
        )

        this.cacheDir := cacheDir
        super.__New(app, components)
    }

    LoadComponents() {
        if (!this._componentsLoaded) {
            for key, cacheObj in this._components {
                if (cacheObj.IsCacheOutdated()) {
                    this.FlushCache(key, false)
                }
            }
        }

        super.LoadComponents()
    }

    SetCacheDir(cacheDir) {       
        this.cacheDir := cacheDir
    }

    FlushCaches(notify := true) {
        for key, cacheObj in this._components
        {
            this.FlushCache(key, false)
        }

        if (notify) {
            this.app.Service("Notifier").Info("Flushed all caches.")
        }
    }

    FlushCache(key, notify := false) {
        if (this._components.Has(key)) {
            this._components[key].FlushCache()

            if (notify) {
                this.app.Service("Notifier").Info("Flushed cache: " . key . ".")
            }
        }
    }

    ChangeCacheDir() {
        cacheDir := this.app.Config.HasProp("CacheDir") ? this.app.Config.CacheDir : this.cacheDir
        
        newDir := DirSelect("*" . this.app.Config.CacheDir, 3, "Create or select the folder to save " . this.app.appName . "'s cache files to")
        
        if (newDir != "") {
            cacheDir := newDir
            this.app.Config.CacheDir := newDir
            this.SetCacheDir(newDir)
            this.FlushCaches()
            this.SetupCaches()
        }

        return cacheDir
    }

    OpenCacheDir() {
        Run(this.cacheDir)
    }
}
