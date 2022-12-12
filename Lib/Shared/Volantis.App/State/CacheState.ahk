class CacheState extends JsonState {
    cacheExpire := 86400

    CachedItems {
        get => this.State.Has("CachedItems") ? this.State["CachedItems"] : this.State["CachedItems"] := Map()
        set => this.State["CachedItems"] := value
    }

    NotFoundItems {
        get => this.State.Has("NotFoundItems") ? this.State["NotFoundItems"] : this.State["NotFoundItems"] := Map()
        set => this.State["NotFoundItems"] := value
    }

    ResponseCodes {
        get => this.State.Has("ResponseCodes") ? this.State["ResponseCodes"] : this.State["ResponseCodes"] := Map()
        set => this.State["ResponseCodes"] := value
    }

    __New(app, cacheDir, stateFilename, cacheExpire := "") {
        if (cacheExpire != "") {
            this.cacheExpire := cacheExpire
        }

        super.__New(app, cacheDir . "\" . stateFilename, true)
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

    GetResponseCode(item) {
        responseCode := 0

        if (this.ResponseCodes.Has(item)) {
            return this.ResponseCodes[item]
        }

        return responseCode
    }

    SetResponseCode(item, responseCode) {
        this.ResponseCodes[item] := responseCode
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

    SetItem(item, responseCode := "") {
        this.CachedItems[item] := FormatTime(,"yyyyMMddHHmmss")

        if (responseCode) {
            this.ResponseCodes[item] := responseCode
        }

        this.SaveState()
    }

    SetNotFoundItem(item) {
        this.NotFoundItems[item] := FormatTime(,"yyyyMMddHHmmss")
        this.ResponseCodes[item] := 404
        this.SaveState()
    }

    RemoveItem(item) {
        save := false

        if (this.CachedItems.Has(item)) {
            this.CachedItems.Delete(item)
            save := true
        }

        if (this.NotFoundItems.Has(item)) {
            this.NotFoundItems.Delete(item)
            save := true
        }

        if (this.ResponseCodes.Has(item)) {
            this.ResponseCodes.Delete(item)
            save := true
        }

        if (save) {
            this.SaveState()
        }
    }

    ClearItems() {
        this.CachedItems.Clear()
        this.NotFoundItems.Clear()
        this.ResponseCodes.Clear()
        this.Version := this.app.Version
        this.SaveState()
    }
}
