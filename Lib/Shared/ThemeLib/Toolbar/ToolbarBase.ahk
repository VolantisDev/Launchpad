class ToolbarBase {
    guiObj := ""
    toolbarButtons := Map()

    __New(app, guiObj) {
        InvalidParameterException.CheckTypes("LauncherGameOpBase", "guiObj", guiObj, "Gui")
        this.guiObj := guiObj
    }

    Show() {
        ; @todo Finish implementing toolbar support
    }
}
