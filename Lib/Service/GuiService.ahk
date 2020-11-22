class GuiService extends ServiceBase {
    guis := Map()

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
            this.AddWindow("MainWindow", MainWindow.new(this.app, "Launchpad", "", "MainWindow"))
        }

        return this.ShowWindow("MainWindow")
    }

    OpenManageWindow() {
        if (!this.WindowExists("ManageWindow")) {
            this.AddWindow("ManageWindow", ManageWindow.new(this.app, "MainWindow", "ManageWindow"))
        }

        return this.ShowWindow("ManageWindow")
    }

    OpenSettingsWindow() {
        if (!this.WindowExists("SettingsWindow")) {
            this.AddWindow("SettingsWindow", SettingsWindow.new(this.app, "MainWindow", "SettingsWindow"))
        }

        return this.ShowWindow("SettingsWindow")
    }

    OpenToolsWindow() {
        if (!this.WindowExists("ToolsWindow")) {
            this.AddWindow("ToolsWindow", ToolsWindow.new(this.app, "MainWindow", "ToolsWindow"))
        }

        return this.ShowWindow("ToolsWindow")
    }

    CloseToolsWindow() {
        this.CloseWindow("ToolsWindow")
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

    WindowIsOpen(key) {
        return this.WindowExists(key)
        ; @todo Make this more accurate?
    }

    CloseWindow(key) {
        if (this.WindowExists(key)) {
            this.guis[key].Close()
        }
    }

    RemoveWindow(key) {
        if (this.WindowExists(key)) {
            this.guis.Delete(key)
        }
    }

    GetGuiObj(key) {
        guiObject := ""

        if (this.guis.Has(key)) {
            guiObject := this.guis[key].guiObj
        }

        return guiObject
    }
}
