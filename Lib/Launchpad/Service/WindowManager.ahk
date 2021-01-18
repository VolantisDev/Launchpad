class WindowManager extends AppComponentServiceBase {
    _registerEvent := LaunchpadEvents.WINDOWS_REGISTER
    _alterEvent := LaunchpadEvents.WINDOWS_ALTER
    children := Map()
    owned := Map()

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

    LauncherWizard(owner := "", parent := "") {
        return this.ShowForm(LauncherWizard.new(this.app, "", owner, parent))
    }

    PlatformEditor(entityObj, mode := "config", owner := "", parent := "") {
        return this.ShowForm(PlatformEditor.new(this.app, entityObj, mode, "", owner, parent))
    }

    LauncherEditor(entityObj, mode := "config", owner := "", parent := "") {
        return this.ShowForm(LauncherEditor.new(this.app, entityObj, mode, "", owner, parent))
    }

    ManagedLauncherEditor(entityObj, mode := "config", owner := "", parent := "") {
        return this.ShowForm(ManagedLauncherEditor.new(this.app, entityObj, mode, "", owner, parent))
    }

    ManagedGameEditor(entityObj, mode := "config", owner := "", parent := "") {
        return this.ShowForm(ManagedGameEditor.new(this.app, entityObj, mode, "", owner, parent))
    }

    DetectedGamesWindow(detectedGames, owner := "", parent := "") {
        return this.ShowForm(DetectedGamesWindow.new(this.app, detectedGames, "DetectedGamesWindow", owner, parent))
    }

    DetectedGameEditor(detectedGameObj, owner := "", parent := "") {
        return this.ShowForm(DetectedGameEditor.new(this.app, detectedGameObj, "Detected Game", "", owner, parent))
    }

    SetupWindow(owner := "", parent := "") {
        return this.ShowForm(SetupWindow.new(this.app, "SetupWindow", owner, parent))
    }

    OpenMainWindow() {
        if (!this.WindowExists("MainWindow")) {
            this.SetItem("MainWindow", MainWindow.new(this.app, "Launchpad", "MainWindow"))
        }

        return this.ShowWindow("MainWindow")
    }

    OpenManageWindow() {
        if (!this.WindowExists("ManageWindow")) {
            this.SetItem("ManageWindow", ManageWindow.new(this.app, "ManageWindow"))
        }

        return this.ShowWindow("ManageWindow")
    }

    OpenPlatformsWindow() {
        if (!this.WindowExists("PlatformsWindow")) {
            this.SetItem("PlatformsWindow", PlatformsWindow.new(this.app, "", "PlatformsWindow"))
        }

        return this.ShowWindow("PlatformsWindow")
    }

    OpenSettingsWindow(owner := "MainWindow") {
        if (!this.WindowExists("SettingsWindow")) {
            this.SetItem("SettingsWindow", SettingsWindow.new(this.app, "SettingsWindow", owner))
        }

        return this.ShowWindow("SettingsWindow")
    }

    OpenToolsWindow(owner := "MainWindow") {
        if (!this.WindowExists("ToolsWindow")) {
            this.SetItem("ToolsWindow", ToolsWindow.new(this.app, "ToolsWindow", owner))
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

        if (this.WindowExists(key)) {
            guiObject := this._components[key].guiObj
        }

        return guiObject
    }
}
