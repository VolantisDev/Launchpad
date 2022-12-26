class UrlObj {
    urlMap := Map(
        "protocol", "https",
        "host", "",
        "path", "",
        "query", Map(),
        "anchor", ""
    )

    Protocol {
        get => this.urlMap["protocol"]
        set => this.urlMap["protocol"] := value
    }

    Host {
        get => this.urlMap["host"]
        set => this.urlMap["host"] := value
    }

    Path {
        get => this.urlMap["path"]
        set => this.urlMap["path"] := value
    }

    Query {
        get => this.urlMap["query"]
        set => this.SetQuery(value)
    }

    QueryStr {
        get => this.GetQueryStr()
        set => this.SetQuery(value)
    }

    Anchor {
        get => this.urlMap["anchor"]
        set => this.urlMap["anchor"] := value
    }

    __New(urlData := "") {
        if (Type(urlData) == "String") {
            urlData := this._splitUrlStr(urlData)
        }

        if (urlData && HasBase(urlData, Map.Prototype)) {
            this._setUrlParts(urlData)
        }
    }

    _splitUrlStr(urlStr) {
        urlMap := Map()

        urlParts := ""
        regexStr := "^((?P<protocol>[^:/?#]+):)?(//(?P<host>[^/?#]*))?(?P<path>[^?#]*)(\?(?P<query>[^#]*))?(#(?P<anchor>.*))?"
        isUrl := RegExMatch(urlStr, regexStr, &urlParts)

        if (urlParts) {
            loop urlParts.Count {
                matchName := urlParts.Name[A_Index]
                matchVal := urlParts[A_Index]
    
                if (matchName) {
                    if (matchName == "query") {
                        matchVal := this._splitQueryStr(matchVal)
                    }
    
                    urlMap[matchName] := matchVal
                }
            }
        }

        return urlMap
    }

    _setUrlParts(urlMap) {
        for key, val in urlMap {
            this.urlMap[key] := val
        }
    }

    _splitQueryStr(queryStr) {
        queryMap := Map()

        for , queryPart in StrSplit(queryStr, "&") {
            queryPartParts := StrSplit(queryPart, "=")
            queryMap[queryPartParts[1]] := queryPartParts.Has(2) ? queryPartParts[2] : ""
        }

        return queryMap
    }

    _compactQueryStr(queryMap) {
        queryStr := ""

        for key, val in queryMap {
            if (queryStr) {
                queryStr .= "&"
            }

            queryStr .= key . "=" . val
        }

        return queryStr
    }

    GetQueryStr() {
        return this._compactQueryStr(this.urlMap["query"])
    }

    SetQuery(queryData) {
        if (Type(queryData) == "String") {
            queryData := this._splitQueryStr(queryData)
        }

        this.urlMap["query"] := queryData
    }

    AddQueryParams(query) {
        if (query) {
            if (Type(query) == "String") {
                query := this._splitQueryStr(query)
            }

            for key, val in query {
                this.urlMap["query"][key] := val
            }
        }

        return this
    }

    ToString(absolute := true) {
        urlStr := absolute
            ? this.Protocol . "://" this.Host
            : ""

        urlStr .= this.Path
        queryStr := this.QueryStr

        if (queryStr) {
            urlStr .= "?" . queryStr
        }

        anchor := this.Anchor

        if (anchor) {
            urlStr .= "#" . anchor
        }

        return urlStr
    }
}
