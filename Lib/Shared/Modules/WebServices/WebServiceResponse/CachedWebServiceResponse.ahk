class CachedWebServiceResponse extends WebServiceResponseBase {
    cacheObj := ""

    __New(webServiceEnt, webServiceReq) {
        if (webServiceEnt.Has("Cache", false)) {
            this.cacheObj := webServiceEnt.cacheObj
        }
        
        super.__New(webServiceEnt, webServiceReq)
    }

    GetHttpStatusCode() {
        responseCode := 0

        if (this.cacheObj) {
            responseCode := this.cacheObj.GetResponseCode(this.webServiceReq.GetPath())
        }

        return responseCode
    }

    GetResponseBody() {
        body := ""
        path := this.webServiceReq.GetPath()

        if (this.cacheObj.ItemExists(path)) {
            body := this.cacheObj.ReadItem(path)
        }

        return body
    }
}
