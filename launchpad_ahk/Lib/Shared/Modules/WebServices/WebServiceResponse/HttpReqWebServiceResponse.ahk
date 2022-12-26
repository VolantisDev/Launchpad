class HttpReqWebServiceResponse extends WebServiceResponseBase {
    httpReqObj := ""

    __New(webServiceEnt, webServiceReq) {
        this.httpReqObj := webServiceReq.GetHttpReq()
        
        super.__New(webServiceEnt, webServiceReq)
    }

    GetHttpStatusCode() {
        return this.httpReqObj.GetStatusCode()
    }

    GetResponseBody() {
        return Trim(this.httpReqObj.GetResponseData())
    }
}
