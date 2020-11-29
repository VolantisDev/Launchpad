class LaunchpadGuiBase extends GuiBase {
    app := ""

    __New(app, title, owner := "", windowKey := "") {
        this.app := app

        if (Type(owner) == "String") {
            owner := app.Windows.GetGuiObj(owner)
        }
        
        super.__New("Launchpad Updater", owner, windowKey)
    }

    Destroy() {
        super.Destroy()

        if (this.windowKey != "") {
            this.app.Windows.RemoveWindow(this.windowKey)
        }
    }
}
