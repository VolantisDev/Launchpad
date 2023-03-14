class MenuResultEvent extends EventBase {
    resultItem := ""
    finished := false

    Result {
        get => this.resultItem
        set => this.resultItem := value
    }

    IsFinished {
        get => this.finished
        set => !!(value)
    }

    __New(eventName, result) {
        this.resultItem := result

        super.__New(eventName)
    }
}
