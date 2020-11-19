class FileCache extends Cache {
    cachePath := 

    __New(app, cachePath := "") {
        if (cachePath == "") {
            cachePath := A_Temp . "\Launchpad\Cache"
        }

        this.cachePath := cachePath
        FileCreateDir, % this.cachePath

        base.__New(app)
    }

    ItemExists(path) {
        return FileExist(this.GetCachePath(path))
    }

    ReadItem(path) {
        item := ""

        if (this.ItemExists(path)) {
            FileRead, item, % this.GetCachePath(path)
        }

        return item
    }

    WriteItem(path, content) {
        this.CreateCacheDir(path)
        path := this.GetCachePath(path)
        FileDelete,%path%
        FileAppend, %content%, %path%
    }

    RemoveItem(path) {
        path := this.GetCachePath(path)

        if (path != "") {
            FileDelete, %path%
        }
    }

    GetItemTimestamp(path) {
        timestamp := ""

        if (this.ItemExists(path)) {
            FileGetTime, timestamp, % this.GetCachePath(path), M
        }

        return timestamp
    }

    FlushCache() {
        FileRemoveDir,% this.cachePath, true
        FileCreateDir, % this.cachePath
    }

    CreateCacheDir(path) {
        path := this.GetCachePath(path)
        SplitPath, path,,cacheDir
        FileCreateDir, %cacheDir%
    }

    GetCachePath(path) {
        return this.cachePath "\" . this.ConvertPathToDestinationFormat(path)
    }

    ConvertPathToDestinationFormat(path) {
        StringReplace, path, path,% "/",% "\", All
        return path
    }

    ImportItemFromUrl(path, url) {
        this.CreateCacheDir(path)
        filePath := this.GetCachePath(path)
        UrlDownloadToFile, %url%, %filePath%
        return filePath
    }

    CopyItem(path, destination) {
        sourcePath := this.GetCachePath(path)
        
        if (path != "" and sourcePath != "" and destination != "" and sourcePath != destination) {
            FileCopy, %sourcePath%, %destination%, true
        }

        return destination
    }
}
