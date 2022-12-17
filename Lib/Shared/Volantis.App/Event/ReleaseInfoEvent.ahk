class ReleaseInfoEvent extends EventBase {
    appObj := ""
    releaseInfoObj := Map()

    App {
        get => this.appObj
    }

    ReleaseInfo {
        get => this.releaseInfoObj
        set => this.releaseInfoObj := value
    }

    __New(eventName, app, releaseInfo := "") {
        this.appObj := app

        if (releaseInfo) {
            this.releaseInfoObj := releaseInfo
        }
        
        super.__New(eventName)
    }
}
