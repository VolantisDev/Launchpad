class ToolbarBase {
    app := ""
    guiObj := ""
    toolbarButtons := Map()

    __New(app, guiObj) {
        InvalidParameterException.CheckTypes("LauncherGameOpBase", "app", app, "Launchpad", "guiObj", guiObj, "Gui")
        this.app := app
        this.guiObj := guiObj
    }

    Show() {
        ; @todo Finish implementing toolbar support
    }
}
