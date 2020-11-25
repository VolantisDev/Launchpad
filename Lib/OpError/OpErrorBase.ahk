class OpErrorBase {
    app := ""
    errorCodeVal := 0
    errorMsgVal := ""

    ErrorCode {
        get => this.errorCodeVal
        set => this.errorCodeVal := value
    }

    ErrorMsg {
        get => this.errorMsgVal
        set => this.errorMsgVal := value
    }

    __New(app, errorMsg := "", errorCode := "") {
        this.app := app

        if (errorMsg != "") {
            this.ErrorMsg := errorMsg
        }

        if (errorCode != "") {
            this.ErrorCode := errorCode
        }
    }
}
