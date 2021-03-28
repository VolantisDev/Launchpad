class AppServiceBase extends ServiceBase {
    app := ""

    __New(app) {
        InvalidParameterException.CheckTypes("AppServiceBase", "app", app, "AppBase")
        this.app := app
        super.__New()
    }
}
