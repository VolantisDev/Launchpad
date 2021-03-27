class AppServiceBase extends ServiceBase {
    app := ""

    __New(app) {
        InvalidParameterException.CheckTypes("LauncherGameOpBase", "app", app, "AppBase")
        this.app := app
        super.__New()
    }
}
