class CacheBase {
    ItemExists(reference) {
        ; Check if the referenced item exists in this cache
    }

    GetItemTimestamp(reference) {
        ; Get the timestamp of the referenced item in seconds
    }

    WriteItem(reference, content) {
        ; Adds or updates an item in the cache
    }

    ReadItem(reference) {
        ; Reads the referenced item from the cache and returns its contents
    }

    RemoveItem(reference) {
        ; Removes the referenced item from the cache
    }

    FlushCache() {
        ; Removes all items from the cache   
    }

    ImportItemFromUrl(reference, url) {
        tempFile := this.app.Config.TempDir . "\cacheDownload"
        DirCreate(this.app.Config.TempDir)
        tempFile := this.DownloadItem(tempFile, url)
        content := FileRead(tempFile)
        
        if (FileExist(tempFile)) {
            FileDelete(tempFile)
        }
        
        this.WriteItem(reference, content)

        return content
    }

    DownloadItem(path, url) {
        Download(url, path)
        return path
    }

    GetCacheAge(reference) {
        timestamp := this.GetItemTimestamp(reference)
        cacheAge := 999999999 ; Random really high number

        if (timestamp != "") {
            now := FormatTime(,"yyyyMMddHHmmss")
            cacheAge := DateDiff(now, timestamp, "Seconds")
        }

        return cacheAge        
    }

    CopyItem(reference, destination) {
        if (this.ItemExists(reference)) {
            content := this.GetItem(reference)
            this.WriteItem(destination, content)
        }
        
        return destination
    }

    ItemNeedsUpdate(reference, maxCacheAge := 86400) {
        needsUpdate := true

        if (this.ItemExists(reference)) {
            needsUpdate := this.GetCacheAge(reference) >= maxCacheAge
        }

        return needsUpdate
    }
}
