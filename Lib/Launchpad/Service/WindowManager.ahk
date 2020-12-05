class WindowManager extends ServiceBase {
    windows := Map()

    GetTheme() {
        return this.app.Themes.GetTheme()
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

    LauncherEditor(launcherGameObj, mode := "config", owner := "", parent := "") {
        return this.ShowForm(LauncherEditor.new(this.app, launcherGameObj, mode, "", owner, parent))
    }

    OpenMainWindow() {
        if (!this.WindowExists("MainWindow")) {
            this.AddWindow("MainWindow", MainWindow.new(this.app, "Launchpad", "MainWindow"))
        }

        return this.ShowWindow("MainWindow")
    }

    OpenUpdaterWindow() {
        if (!this.WindowExists("UpdaterWindow")) {
            this.AddWindow("UpdaterWindow", UpdaterWindow.new(this.app, "Updater - Launchpad", "MainWindow"))
        }

        return this.ShowWindow("UpdaterWindow")
    }

    OpenManageWindow(parent := "MainWindow") {
        if (!this.WindowExists("ManageWindow")) {
            this.AddWindow("ManageWindow", ManageWindow.new(this.app, "", "ManageWindow", "", parent))
        }

        return this.ShowWindow("ManageWindow")
    }

    OpenSettingsWindow(parent := "MainWindow") {
        if (!this.WindowExists("SettingsWindow")) {
            this.AddWindow("SettingsWindow", SettingsWindow.new(this.app, "SettingsWindow", "", parent))
        }

        return this.ShowWindow("SettingsWindow")
    }

    OpenToolsWindow(parent := "MainWindow") {
        if (!this.WindowExists("ToolsWindow")) {
            this.AddWindow("ToolsWindow", ToolsWindow.new(this.app, "ToolsWindow", "", parent))
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
