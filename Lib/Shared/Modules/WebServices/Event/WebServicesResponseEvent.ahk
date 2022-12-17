class WebServicesResponseEvent extends EventBase {
    _requestObj := ""
    _responseObj := ""
    
    __New(eventName, requestObj, responseObj) {
        this._requestObj := requestObj
        this._responseObj := responseObj

        super.__New(eventName)
    }

    Request {
        get => this._requestObj
    }

    Response {
        get => this._responseObj
        set => this._responseObj := value
    }
}
