class AppComponentServiceBase extends ComponentServiceBase {
    app := ""

    __New(app) {
        InvalidParameterException.CheckTypes("LauncherGameOpBase", "app", app, "Launchpad")
        this.app := app
        super.__New()
    }
}
