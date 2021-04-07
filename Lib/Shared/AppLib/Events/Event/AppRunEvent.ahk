class AppRunEvent extends EventBase {
    appObj := ""
    configObj := ""

    App {
        get => this.appObj
    }

    Config {
        get => this.configObj
    }

    __New(eventName, app, config) {
        this.appObj := app
        this.configObj := config
        super.__New(eventName)
    }
}
