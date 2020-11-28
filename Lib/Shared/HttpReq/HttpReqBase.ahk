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
    requestHeaders := ""
    responseHeaders := ""
    responseBody := ""
    autoRedirect := true
    pos := ""
    returnCode := ""

    __New(url) {
        this.url := url
    }

    Send(method := "GET", data := "") {
        return this.returnCode
    }

    GetStatusCode() {
        return this.statusCode
    }

    GetResponseBody() {
        return this.responseBody
    }
}
