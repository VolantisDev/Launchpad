class FileCache extends CacheBase {
    cachePath := ""

    __New(app, stateObj, cachePath) {
        InvalidParameterException.CheckTypes("FileCache", "cachePath", cachePath, "")
        InvalidParameterException.CheckEmpty("FileCache", "cachePath", cachePath)
        this.cachePath := cachePath

        if (!DirExist(cachePath)) {
            DirCreate(cachePath)
        }

        super.__New(app, stateObj)
    }

    ItemExists(path) {
        return super.ItemExists(path) && FileExist(this.GetCachePath(path))
    }

    ReadItemAction(path) {
        return (this.ItemExists(path)) ? FileRead(this.GetCachePath(path)) : ""
    }

    WriteItemAction(path, content) {
        this.CreateCacheDir(path)
        path := this.GetCachePath(path)

        if (FileExist(path)) {
            FileDelete(path)
        }
        
        FileAppend(content, path)
        return true
    }

    RemoveItemAction(path) {
        path := this.GetCachePath(path)

        if (path != "" && FileExist(path)) {
            FileDelete(path)
        }
    }

    FlushCacheAction() {
        if (DirExist(this.cachePath)) {
            DirDelete(this.cachePath, true)
        }
        
        DirCreate(this.cachePath)
    }

    CreateCacheDir(path) {
        path := this.GetCachePath(path)
        SplitPath(path,,cacheDir)
        DirCreate(cacheDir)
    }

    GetCachePath(path) {
        return this.cachePath "\" . this.ConvertPathToDestinationFormat(path)
    }

    ConvertPathToDestinationFormat(path) {
        return StrReplace(path, "/", "--")
    }

    ImportItemFromUrl(path, url) {
        this.CreateCacheDir(path)
        filePath := this.GetCachePath(path)

        Download(url, filePath)
        this.stateObj.SetItem(path)
        return filePath
    }

    CopyItem(path, destination) {
        sourcePath := this.GetCachePath(path)
        
        if (path != "" && sourcePath != "" && destination != "" && sourcePath != destination) {
            FileCopy(sourcePath, destination, true)
        }

        return destination
    }

    GetCachedDownload(cachePath, downloadUrl) {
        filePath := cachePath

        if (!this.ItemExists(cachePath) || this.ItemNeedsUpdate(cachePath)) {
            filePath := this.ImportItemFromUrl(cachePath, downloadUrl)
        } else {
            filePath := this.GetCachePath(cachePath)
        }

        return filePath
    }
}
