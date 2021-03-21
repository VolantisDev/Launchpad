class CacheState extends JsonAppState {
    cacheExpire := 86400

    CachedItems {
        get => this.State.Has("CachedItems") ? this.State["CachedItems"] : this.State["CachedItems"] := Map()
        set => this.State["CachedItems"] := value
    }

    NotFoundItems {
        get => this.State.Has("NotFoundItems") ? this.State["NotFoundItems"] : this.State["NotFoundItems"] := Map()
        set => this.State["NotFoundItems"] := value
    }

    __New(filePath, cacheExpire := "") {
        if (cacheExpire != "") {
            this.cacheExpire := cacheExpire
        }

        super.__New(filePath, true)
    }

    Exists(item) {
        return this.CachedItems.Has(item) || this.NotFoundItems.Has(item)
    }

    GetTimestamp(item) {
        timestamp := ""

        if (this.Exists(item)) {
            if (this.CachedItems.Has(item)) {
                timestamp := this.CachedItems[item]
            } else if (this.NotFoundItems.Has(item)) {
                timestamp := this.NotFoundItems[item]
            }
        }

        return timestamp
    }

    IsExpired(item, maxCacheAge := "") {
        if (maxCacheAge == "") {
            maxCacheAge := this.cacheExpire
        }

        expired := true

        if (this.Exists(item)) {
            expired := this.GetCacheAge(item) >= maxCacheAge
        }

        return expired
    }

    GetCacheAge(item) {
        cacheAge := 999999999 ; Just a really high number

        if (this.Exists(item)) {
            now := FormatTime(,"yyyyMMddHHmmss")
            timestamp := this.GetTimestamp(item)
            cacheAge := DateDiff(now, timestamp, "Seconds")
        }

        return cacheAge
    }

    SetItem(item) {
        this.CachedItems[item] := FormatTime(,"yyyyMMddHHmmss")
        this.SaveState()
    }

    SetNotFoundItem(item) {
        this.NotFoundItems[item] := FormatTime(,"yyyyMMddHHmmss")
        this.SaveState()
    }

    RemoveItem(item) {
        if (this.CachedItems.Has(item)) {
            this.CachedItems.Delete(item)
            this.SaveState()
        }

        if (this.NotFoundItems.Has(item)) {
            this.NotFoundItems.Delete(item)
            this.SaveState()
        }
    }

    ClearItems() {
        this.CachedItems.Clear()
        this.NotFoundItems.Clear()
        this.SaveState()
    }
}
