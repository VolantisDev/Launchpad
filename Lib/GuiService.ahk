class GuiService {
    app := ""
    guis := Map()

    __New(app) {
        this.app := app
    }

    DialogBox(title, text, owner := "", buttons := "*&Yes|&No") {
        return this.ShowDialog(DialogBox.new(this.app, title, text, owner, buttons))
    }

    SingleInputBox(title, text, defaultValue := "", owner := "", isPassword := false) {
        return this.ShowDialog(SingleInputBox.new(this.app, title, text, defaultValue, owner, isPassword))
    }

    ProgressIndicator(title, text, owner := "", allowCancel := false, progressRange := "0-100", initialPosition := 0, detailText := true) {
        return this.ShowDialog(ProgressIndicator.new(this.app, title, text, owner, allowCancel, progressRange, initialPosition, detailText))
    }

    OpenMainWindow() {
        if (!this.WindowExists("MainWindow")) {
            this.AddWindow("MainWindow", MainWindow.new(this.app, "Launchpad"))
        }

        return this.ShowWindow("MainWindow")
    }

    OpenLauncherManager() {
        if (!this.WindowExists("LauncherManager")) {
            this.AddWindow("LauncherManager", LauncherManager.new(this.app, "MainWindow"))
        }

        return this.ShowWindow("LauncherManager")
    }

    OpenSettingsWindow() {
        if (!this.WindowExists("SettingsWindow")) {
            this.AddWindow("SettingsWindow", SettingsWindow.new(this.app, "MainWindow"))
        }

        return this.ShowWindow("SettingsWindow")
    }

    OpenToolsWindow() {
        if (!this.WindowExists("ToolsWindow")) {
            this.AddWindow("ToolsWindow", ToolsWindow.new(this.app, "MainWindow"))
        }

        return this.ShowWindow("ToolsWindow")
    }

    CloseToolsWindow() {
        if (this.WindowExists("ToolsWindow")) {
            this.guis["ToolsWindow"].Close()
        }
    }

    ShowDialog(instance) {
        return instance.Show()
    }

    AddWindow(key, instance) {
        this.guis[key] := instance
    }

    WindowExists(key) {
        return this.guis.Has(key)
    }

    ShowWindow(key) {
        return (this.guis.Has(key)) ? this.guis[key].Show() : false
    }

    GetGuiObj(key) {
        guiObject := ""

        if (this.guis.Has(key)) {
            guiObject := this.guis[key].guiObj
        }

        return guiObject
    }
}
