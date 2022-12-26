class WebServiceResponseBase {
    webServiceEnt := ""
    webServiceReq := ""
    successCodes := [200]
    notFoundCodes := [404]
    
    __New(webServiceEnt, webServiceReq) {
        this.webServiceEnt := webServiceEnt
        this.webServiceReq := webServiceReq
    }

    GetHttpStatusCode() {
        return ""
    }

    GetResponseBody() {
        return ""
    }

    GetJsonData() {
        body := this.GetResponseBody()
        
        if (!body) {
            body := "{}"
        }

        return JsonData().FromString(&body)
    }

    IsSuccessful() {
        httpCode := this.GetHttpStatusCode()
        success := false

        for , successCode in this.successCodes {
            if (httpCode == successCode) {
                success := true
                break
            }
        }

        return success
    }

    IsNotFound() {
        httpCode := this.GetHttpStatusCode()
        notFound := false

        for , notFoundCode in this.notFoundCodes {
            if (httpCode == notFoundCode) {
                notFound := true
                break
            }
        }

        return notFound
    }
}
