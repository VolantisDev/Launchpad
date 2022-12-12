class WebServiceRequestBase {
    eventMgr := ""
    webServiceEnt := ""
    cacheObj := ""
    path := ""
    method := ""
    data := ""
    useAuthentication := false
    httpReqObj := ""
    responseObj := ""
    cacheResponse := true
    _url := ""

    Url {
        get => this._getUrl()
    }

    Response {
        get => this.responseObj
    }

    __New(eventMgr, webServiceEnt, cacheObj, method := "", path := "", data := "", useAuthentication := false, cacheResponse := true) {
        this.eventMgr := eventMgr
        this.webServiceEnt := webServiceEnt
        this.cacheObj := cacheObj


        if (!method) {
            method := "GET"
        }

        this.method := method

        if (path) {
            this.path := path
        }

        if (data) {
            this.data := data
        }

        this.useAuthentication := useAuthentication
        this.cacheResponse := cacheResponse
    }

    GetPath() {
        return this.path
    }

    SetPath(path := "") {
        this.path := path
        
        if (this._url) {
            this._url.Path := this.webServiceEnt["Provider"].Path(path)
        }

        return this
    }

    GetMethod() {
        return this.method
    }

    SetMethod(method := "GET") {
        this.method := method

        return this
    }

    GetData() {
        return this.data
    }

    SetData(data := "", clearCache := false) {
        this.data := data
        
        if (clearCache) {
            this.cacheObj.RemoveItem(this.GetPath())
        }

        return this
    }

    GetUseAuthentication() {
        return this.useAuthentication
    }

    SetUseAuthentication(useAuthentication := false) {
        this.useAuthentication := useAuthentication

        return this
    }

    GetHttpReq() {
        if (!this.httpReqObj) {
            this.httpReqObj := WinHttpReq(this.Url)
        }

        return this.httpReqObj
    }

    SetHttpReq(httpReqObj := "") {
        this.httpReqObj := httpReqObj
    }

    _getUrl() {
        if (!this._url) {
            this._url := this.webServiceEnt["Provider"].Url(this.path)
        }

        return this._url
    }

    Send(resend := false) {
        if (resend || !this.responseObj) {
            if (this.RequestIsCached()) {
                this.responseObj := this._createCachedResponse()
            } else {
                httpReqObj := this.GetHttpReq()

                if (this.GetUseAuthentication() && this.webServiceEnt["Provider"].Has("Authenticator", false)) {
                    authenticator := this.webServiceEnt["Provider"]["Authenticator"]
    
                    if (authenticator.NeedsRefresh(this.webServiceEnt)) {
                        authenticator.RefreshAuthentication(this.webServiceEnt)
                    }
    
                    authenticator.AlterRequest(this.webServiceEnt, this, httpReqObj)
                }

                event := WebServiceRequestEvent(WebServicesEvents.WEB_SERVICES_HTTP_REQ_ALTER, this)
                this.eventMgr.DispatchEvent(event)

                event := WebServiceRequestEvent(WebServicesEvents.WEB_SERVICES_REQUEST_PRESEND, this)
                this.eventMgr.DispatchEvent(event)

                httpReqObj.Send(this.GetMethod(), this.GetData())
                this.responseObj := this._createHttpReqResponse()
                this._cacheResponse()
            }

            event := WebServiceResponseEvent(WebServicesEvents.WEB_SERVICES_RESPONSE_ALTER, this, this.responseObj)
            this.eventMgr.DispatchEvent(event)

            this.responseObj := event.Response
        }
        
        return this.responseObj
    }

    RequestIsCached() {
        path := this.GetPath()

        return this.cacheObj.ItemExists(path && !this.cacheObj.ItemNeedsUpdate(path))
    }

    _createCachedResponse() {
        response := CachedWebServiceResponse(this.webServiceEnt, this)

        event := WebServiceResponseEvent(WebServicesEvents.WEB_SERVICES_CACHED_RESPONSE_CREATED, this, response)
        this.eventMgr.DispatchEvent(event)

        return event.Response
    }

    _createHttpReqResponse() {
        response := HttpReqWebServiceResponse(this.webServiceEnt, this)

        event := WebServiceResponseEvent(WebServicesEvents.WEB_SERVICES_HTTP_RESPONSE_CREATED, this, response)
        this.eventMgr.DispatchEvent(event)

        return event.Response
    }

    _cacheResponse() {
        if (this.responseObj && this.cacheResponse) {
            path := this.GetPath()

            if (this.responseObj.IsSuccessful()) {
                body := this.responseObj.GetResponseBody()

                if (body) {
                    this.cacheObj.WriteItem(path, body, this.responseObj.GetHttpStatusCode())
                } else {
                    ; Response is empty, delete any existing cache for this item
                    this.cacheObj.RemoveItem(path)
                }
            } else if (this.responseObj.IsNotFound()) {
                this.cacheObj.SetNotFound(path)
            }
        }
    }
}
