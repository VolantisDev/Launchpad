class ObjectCache extends Cache {
    cacheObj := {}

    __New(app, cacheObj := "") {
        if (cacheObj != "") {
            this.cacheObj := cacheObj
        }
        base.__New(app)
    }

    ItemExists(key) {
        return this.cacheObj.HasKey(key)
    }

    GetItemTimestamp(key) {
        return this.ItemExists(key) ? this.cacheObj[key].timestamp : ""
    }

    WriteItem(key, content) {
        FormatTime, now,,yyyyMMddHHmmss
        this.cacheObj[key] := {content: content, timestamp: now}
    }

    ReadItem(key) {
        return this.ItemExists(key) ? this.cacheObj[key].content : ""
    }

    RemoveItem(key) {
        this.cacheObj.Delete(key)
    }

    FlushCache() {
        this.cacheObj := {}
    }
}
