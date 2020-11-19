class ApiCache {
    app := {}
    cachePath := A_Temp . "\Launchpad\API"

    __New(app, cachePath := "") {
        this.app := app

        if (cachePath != "") {
            this.cachePath := cachePath
        }

        if (!FileExist(this.cachePath)) {
            FileCreateDir, % this.cachePath
        }
    }

    ConvertPathToDestinationFormat(path) {
        StringReplace, path, path,% "/",% "\", All
        return path
    }

    GetCachePath(path) {
        return this.cachePath "\" . this.ConvertPathToDestinationFormat(path)
    }

    ItemExists(path) {
        return FileExist(this.GetCachePath(path))
    }

    CreateCacheDir(path) {
        path := this.GetCachePath(path)
        SplitPath, path,,cacheDir
        FileCreateDir, %cacheDir%
    }

    ImportFromUrl(url, path) {
        this.CreateCacheDir(path)
        filePath := this.GetCachePath(path)
        UrlDownloadToFile, %url%, %filePath%
        return filePath
    }

    GetCacheAge(path) {
        cacheAge := ""

        if (this.ItemExists(path)) {
            FileGetTime, fileTime, % this.GetCachePath(path), M
            EnvSub, cacheAge, %fileTime%, Seconds
        }

        return cacheAge
    }

    ItemNeedsUpdate(path, maxCacheAge := 86400) {
        needsUpdate := true

        if (this.ItemExists(path)) {
            needsUpdate := this.GetCacheAge(path) >= maxCacheAge
        }

        return needsUpdate
    }

    ReadItem(path) {
        item := ""

        if (this.ItemExists(path)) {
            FileRead, item, % this.GetCachePath(path)
        }

        return item
    }

    CopyItem(path, destination) {
        sourcePath := this.GetCachePath(path)
        
        if (path != "" and sourcePath != "" and destination != "" and sourcePath != destination) {
            FileCopy, %sourcePath%, %destination%, true
        }

        return destination
    }

    FlushCache() {
        FileRemoveDir,% this.cachePath, true
        FileCreateDir, % this.cachePath
        this.app.Toast("Cleared API cache.")
    }
}
