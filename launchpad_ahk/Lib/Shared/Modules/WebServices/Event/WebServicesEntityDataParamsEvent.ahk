class WebServicesEntityDataParamsEvent extends EntityEvent {
    _webService := ""
    _params := ""
    
    __New(eventName, entityTypeId, entityObj, webService, params) {
        this._webService := webService
        this._params := params

        super.__New(eventName, entityTypeId, entityObj)
    }

    WebService {
        get => this._webService
    }

    Params {
        get => this._params
        set => this._params := value
    }
}
