class AppComponentServiceBase extends ComponentServiceBase {
    app := ""

    __New(app, components := "", autoLoad := true) {
        InvalidParameterException.CheckTypes("LauncherGameOpBase", "app", app, "Launchpad")
        this.app := app
        super.__New(app.Events, components, autoLoad)
    }
}
