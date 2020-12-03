class LaunchpadGuiBase extends GuiBase {
    app := ""

    __New(app, title, owner := "", windowKey := "") {
        InvalidParameterException.CheckTypes("LauncherGameOpBase", "app", app, "Launchpad")
        this.app := app

        if (Type(owner) == "String") {
            owner := app.Windows.GetGuiObj(owner)
        }
        
        super.__New(title, app.Themes.GetTheme(), owner, windowKey)
    }

    Destroy() {
        super.Destroy()

        if (this.windowKey != "") {
            this.app.Windows.RemoveWindow(this.windowKey)
        }
    }
}
