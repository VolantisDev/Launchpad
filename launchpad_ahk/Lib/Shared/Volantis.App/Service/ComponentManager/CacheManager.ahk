class CacheManager extends ComponentManagerBase {
    config := ""

    __New(config, container, eventMgr, notifierObj) {
        this.config := config
        super.__New(container, "cache.", eventMgr, notifierObj, CacheBase)
    }

    FlushCaches(notify := true, force := false) {
        flushed := 0

        for index, cacheName in this.Names() {
            if (this.FlushCache(cacheName, false, force)) {
                flushed += 1
            }
        }

        if (flushed && notify) {
            this.notifierObj.Info("Flushed " . flushed . " caches")
        }
    }

    FlushCache(cacheId, notify := true, force := false) {
        if (!this.Has(cacheId)) {
            throw ComponentException("Cache Manager does not have cache id " . cacheId)
        }

        flushed := this[cacheId].FlushCache(force)

        if (flushed && notify) {
            this.notifierObj.Info("Flushed cache: " . cacheId)
        }

        return flushed
    }

    SetCacheDir(cacheDir) {
        this.config["cache_dir"] := cacheDir
        this.config.SaveConfig()
    }

    ChangeCacheDir() {
        cacheDir := this.config.Has("cache_dir") ? this.config["cache_dir"] : ""
        
        newDir := DirSelect("*" . cacheDir, 3, "Create or select the main folder to save cache files to")
        
        if (newDir != "") {
            cacheDir := newDir
            this.config["cache_dir"] := newDir
            this.config.SaveConfig()
            this.FlushCaches()
            this.SetupCaches()
        }

        return cacheDir
    }

    OpenCacheDir() {
        Run(this.config["cache_dir"])
    }
}
