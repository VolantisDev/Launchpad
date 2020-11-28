class WindowManager extends ServiceBase {
    windows := Map()

    DialogBox(title, text, owner := "", buttons := "*&Yes|&No") {
        return this.ShowDialog(DialogBox.new(this.app, title, text, owner, buttons))
    }

    SingleInputBox(title, text, defaultValue := "", owner := "", isPassword := false) {
        return this.ShowDialog(SingleInputBox.new(this.app, title, text, defaultValue, owner, isPassword))
    }

    ProgressIndicator(title, text, owner := "", allowCancel := false, progressRange := 100, initialPosition := 0, detailText := true) {
        return this.ShowDialog(ProgressIndicator.new(this.app, title, text, owner, allowCancel, progressRange, initialPosition, detailText))
    }

    LauncherEditor(launcherGameObj, mode := "config", owner := "") {
        return this.ShowForm(LauncherEditor.new(this.app, launcherGameObj, mode, owner))
    }

    OpenMainWindow() {
        if (!this.WindowExists("MainWindow")) {
            this.AddWindow("MainWindow", MainWindow.new(this.app, "Launchpad", "", "MainWindow"))
        }

        return this.ShowWindow("MainWindow")
    }

    OpenUpdaterWindow() {
        if (!this.WindowExists("UpdaterWindow")) {
            this.AddWindow("UpdaterWindow", UpdaterWindow.new(this.app, "", "MainWindow"))
        }

        return this.ShowWindow("UpdaterWindow")
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

    ShowForm(instance) {
        return instance.Show()
    }

    AddWindow(key, instance) {
        this.windows[key] := instance
    }

    WindowExists(key) {
        return this.windows.Has(key)
    }

    GetWindow(key) {
        window := ""

        if (this.WindowExists(key)) {
            window := this.windows[key]
        }

        return window
    }

    ShowWindow(key) {
        return (this.windows.Has(key)) ? this.windows[key].Show() : false
    }

    WindowIsOpen(key) {
        return this.WindowExists(key)
        ; @todo Make this more accurate?
    }

    CloseWindow(key) {
        if (this.WindowExists(key)) {
            this.windows[key].Close()
        }
    }

    RemoveWindow(key) {
        if (this.WindowExists(key)) {
            this.windows.Delete(key)
        }
    }

    GetGuiObj(key) {
        guiObject := ""

        if (this.windows.Has(key)) {
            guiObject := this.windows[key].guiObj
        }

        return guiObject
    }
}
