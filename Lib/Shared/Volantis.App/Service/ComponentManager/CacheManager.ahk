class CacheManager extends AppComponentManagerBase {
    __New(container, eventMgr, notifierObj) {
        super.__New(container, eventMgr, notifierObj, "cache.", CacheBase)
    }

    FlushCaches(notify := true, force := false) {
        flushed := 0

        for index, cacheName in this.Names() {
            if (this.FlushCache(cacheName, false, force)) {
                flushed += 1
            }
        }

        if (flushed && notify) {
            this.app.Service("Notifier").Info("Flushed " . flushed . " caches")
        }
    }

    FlushCache(cacheId, notify := true, force := false) {
        if (!this.Has(cacheId)) {
            throw ComponentException("Cache Manager does not have cache id " . cacheId)
        }

        flushed := this[cacheId].FlushCache(force)

        if (flushed && notify) {
            this.app.Service("Notifier").Info("Flushed cache: " . cacheId)
        }

        return flushed
    }

    SetCacheDir(cacheDir) {
        this.app.Config["cache_dir"] := cacheDir
        this.app.Config.SaveConfig()
    }

    ChangeCacheDir() {
        cacheDir := this.app.Config.Has("cache_dir") ? this.app.Config["cache_dir"] : ""
        
        newDir := DirSelect("*" . cacheDir, 3, "Create or select the main folder to save " . this.app.appName . "'s cache files to")
        
        if (newDir != "") {
            cacheDir := newDir
            this.app.Config["cache_dir"] := newDir
            this.app.Config.SaveConfig()
            this.FlushCaches()
            this.SetupCaches()
        }

        return cacheDir
    }

    OpenCacheDir() {
        Run(this.app.Config["cache_dir"])
    }
}
