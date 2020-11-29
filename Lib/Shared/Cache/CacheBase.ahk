class CacheBase {

    /**
    * ABSTRACT METHODS
    */

    ItemExists(reference) {
        throw(MethodNotImplementedException.new("CacheBase", "ItemExists"))
    }

    GetItemTimestamp(reference) {
        throw(MethodNotImplementedException.new("CacheBase", "GetItemTimestamp"))
    }

    WriteItem(reference, content) {
        throw(MethodNotImplementedException.new("CacheBase", "WriteItem"))
    }

    ReadItem(reference) {
        throw(MethodNotImplementedException.new("CacheBase", "ReadItem"))
    }

    RemoveItem(reference) {
        throw(MethodNotImplementedException.new("CacheBase", "RemoveItem"))
    }

    FlushCache() {
        throw(MethodNotImplementedException.new("CacheBase", "FlushCache"))
    }

    /**
    * IMPLEMENTED METHODS
    */

    ImportItemFromUrl(reference, url) {
        tempFile := this.app.Config.TempDir . "\cacheDownload"
        DirCreate(this.app.Config.TempDir)
        Download(url, tempFile)
        content := FileRead(tempFile)
        
        if (FileExist(tempFile)) {
            FileDelete(tempFile)
        }
        
        this.WriteItem(reference, content)

        return content
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
