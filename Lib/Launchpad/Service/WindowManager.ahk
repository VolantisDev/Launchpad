class WindowManager extends AppComponentServiceBase {
    GetTheme() {
        return this.app.Themes.GetItem()
    }

    DialogBox(title, text, owner := "", parent := "", buttons := "*&Yes|&No") {
        return this.ShowDialog(DialogBox.new(title, this.GetTheme(), text, "", owner, parent, buttons))
    }

    SingleInputBox(title, text, defaultValue := "", owner := "", parent := "", isPassword := false) {
        return this.ShowDialog(SingleInputBox.new(title, this.GetTheme(), text, defaultValue, "", owner, parent, isPassword))
    }

    ProgressIndicator(title, text, owner := "", parent := "", allowCancel := false, progressRange := 100, initialPosition := 0, detailText := true) {
        return this.ShowDialog(ProgressIndicator.new(title, this.GetTheme(), text, "", owner, parent, allowCancel, progressRange, initialPosition, detailText))
    }

    LauncherEditor(entityObj, mode := "config", owner := "", parent := "") {
        return this.ShowForm(LauncherEditor.new(this.app, entityObj, mode, "", owner, parent))
    }

    OpenMainWindow() {
        if (!this.WindowExists("MainWindow")) {
            this.SetItem("MainWindow", MainWindow.new(this.app, "Launchpad", "MainWindow"))
        }

        return this.ShowWindow("MainWindow")
    }

    OpenManageWindow(parent := "MainWindow") {
        if (!this.WindowExists("ManageWindow")) {
            this.SetItem("ManageWindow", ManageWindow.new(this.app, "", "ManageWindow", "", parent))
        }

        return this.ShowWindow("ManageWindow")
    }

    OpenSettingsWindow(parent := "MainWindow") {
        if (!this.WindowExists("SettingsWindow")) {
            this.SetItem("SettingsWindow", SettingsWindow.new(this.app, "SettingsWindow", "", parent))
        }

        return this.ShowWindow("SettingsWindow")
    }

    OpenToolsWindow(parent := "MainWindow") {
        if (!this.WindowExists("ToolsWindow")) {
            this.SetItem("ToolsWindow", ToolsWindow.new(this.app, "ToolsWindow", "", parent))
        }

        return this.ShowWindow("ToolsWindow")
    }

    CloseToolsWindow() {
        this.CloseWindow("ToolsWindow")
    }

    ShowDialog(instance) {
        return instance.Show()
    }

    ShowForm(instance) {
        return instance.Show()
    }

    WindowExists(key) {
        return this._components.Has(key)
    }

    ShowWindow(key) {
        return (this._components.Has(key)) ? this._components[key].Show() : false
    }

    WindowIsOpen(key) {
        return this.WindowExists(key)
        ; @todo Make this more accurate?
    }

    CloseWindow(key) {
        if (this.WindowExists(key)) {
            this._components[key].Close()
        }
    }

    GetGuiObj(key) {
        guiObject := ""

        if (this._components.Has(key)) {
            guiObject := this._components[key].guiObj
        }

        return guiObject
    }
}
