class WebServiceRequestEvent extends EventBase {
    _requestObj := ""
    
    __New(eventName, requestObj) {
        this._requestObj := requestObj

        super.__New(eventName)
    }

    Request {
        get => this.requestObj
    }

    HttpReq {
        get => this.Request.GetHttpReq()
    }
}
