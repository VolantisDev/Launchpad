class HttpReqBase {
    url := ""
    timeout := -1
    proxy := ""
    codepage := ""
    charset := ""
    saveAs := ""
    response := ""
    statusCode := 0
    responseData := ""
    requestHeaders := Map()
    responseHeaders := ""
    responseBody := ""
    autoRedirect := true
    pos := ""
    returnCode := ""

    __New(url) {
        this.url := url
    }

    /**
    * ABSTRACT METHODS
    */

    Send(method := "GET", data := "") {
        throw MethodNotImplementedException.new("HttpReqBase", "Send")
    }

    /**
    * IMPLEMENTED METHODS
    */

    GetStatusCode() {
        return this.statusCode
    }

    GetResponseBody() {
        return this.responseBody
    }

    GetResponseData() {
        return this.responseData
    }
}
