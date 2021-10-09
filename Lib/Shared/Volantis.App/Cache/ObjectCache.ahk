class ObjectCache extends CacheBase {
    cacheObj := Map()

    __New(app, stateObj, cacheObj := "") {
        if (cacheObj != "") {
            InvalidParameterException.CheckTypes("ObjectCache", "cacheObj", cacheObj, "Map")
            this.cacheObj := cacheObj
        }
        
        super.__New(app, stateObj)
    }

    WriteItemAction(key, content) {
        this.cacheObj[key] := {content: content, timestamp: FormatTime(,"yyyyMMddHHmmss")}
        return true
    }

    ReadItemAction(key) {
        return this.ItemExists(key) ? this.cacheObj[key].content : ""
    }

    RemoveItemAction(key) {
        this.cacheObj.Delete(key)
    }

    FlushCacheAction() {
        this.cacheObj := Map()
        return true
    }
}
