class AppServiceBase {
    app := ""

    __New(app) {
        InvalidParameterException.CheckTypes("AppServiceBase", "app", app, "AppBase")
        this.app := app
    }
}
