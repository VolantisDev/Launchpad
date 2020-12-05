class LaunchpadGuiBase extends GuiBase {
    app := ""

    __New(app, title, windowKey := "", owner := "", parent := "") {
        InvalidParameterException.CheckTypes("LauncherGameOpBase", "app", app, "Launchpad")
        this.app := app

        if (Type(owner) == "String") {
            owner := app.Windows.GetGuiObj(owner)
        }

        if (Type(parent) == "String") {
            parent := app.Windows.GetGuiObj(parent)
        }
        
        super.__New(title, app.Themes.GetTheme(), windowKey, owner, parent)
    }

    Destroy() {
        super.Destroy()

        if (this.windowKey != "") {
            this.app.Windows.RemoveWindow(this.windowKey)
        }
    }
}
