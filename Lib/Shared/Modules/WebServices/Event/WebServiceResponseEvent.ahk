class WebServiceResponseEvent extends EventBase {
    _responseObj := ""
    
    __New(eventName, responseObj) {
        this._responseObj := responseObj

        super.__New(eventName)
    }

    Response {
        get => this._responseObj
        set => this._responseObj := value
    }
}
