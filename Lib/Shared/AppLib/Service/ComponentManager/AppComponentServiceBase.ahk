class AppComponentServiceBase extends ComponentServiceBase {
    app := ""

    __New(app, components := "", autoLoad := true) {
        InvalidParameterException.CheckTypes("AppComponentServiceBase", "app", app, "AppBase")
        this.app := app
        super.__New(app.Events, components, autoLoad)
    }
}
