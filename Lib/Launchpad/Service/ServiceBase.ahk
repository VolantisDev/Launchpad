class ServiceBase {
    app := ""

    __New(app) {
        InvalidParameterException.CheckTypes("LauncherGameOpBase", "app", app, "Launchpad")
        this.app := app
    }
}
