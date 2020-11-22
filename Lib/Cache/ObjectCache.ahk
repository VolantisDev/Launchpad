class ObjectCache extends Cache {
    cacheObj := Map()

    __New(app, cacheObj := "") {
        if (cacheObj != "") {
            this.cacheObj := cacheObj
        }
        
        super.__New(app)
    }

    ItemExists(key) {
        return this.cacheObj.Has(key)
    }

    GetItemTimestamp(key) {
        return this.ItemExists(key) ? this.cacheObj[key].timestamp : ""
    }

    WriteItem(key, content) {
        this.cacheObj[key] := {content: content, timestamp: FormatTime(,"yyyyMMddHHmmss")}
    }

    ReadItem(key) {
        return this.ItemExists(key) ? this.cacheObj[key].content : ""
    }

    RemoveItem(key) {
        this.cacheObj.Delete(key)
    }

    FlushCache() {
        this.cacheObj := Map()
    }
}
