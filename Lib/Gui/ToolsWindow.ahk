class ToolsWindow extends GuiBase {
    windowOptions := "+AlwaysOnTop -Caption Border"
    contentWidth := 400
    buttonHeight := 40
    positionAtMouseCursor := true
    nextPos := "xm"

    __New(app, owner := "", windowKey := "") {
        this.backgroundColor := this.accentDarkColor
        super.__New(app, "Tools", owner, windowKey)
    }

    Controls() {
        super.Controls()
        this.AddToolButton("&Reload Launcher File", "ReloadLauncherFile")
        this.AddToolButton("&Clean Launchers", "CleanLaunchers")
        this.AddToolButton("&Validate Launchers", "ValidateLaunchers")
        this.AddToolButton("&Flush Cache", "FlushCache")
        this.AddToolButton("&Update Launchpad", "CheckForUpdates")
        this.AddToolButton("Update &Dependencies", "UpdateDependencies")
        this.AddToolButton("&Open Website", "OpenWebsite")
        this.AddToolButton("Provide &Feedback", "ProvideFeedback")
    }

    AddToolButton(buttonLabel, ctlName) {
        width := (this.contentWidth - this.margin) / 2
        btn := this.guiObj.AddButton("v" . ctlName . " " . this.nextPos . " w" . width . " h" . this.buttonHeight, buttonLabel)
        btn.OnEvent("Click", "On" . ctlName)
        this.nextPos := this.nextPos == "xm" ? "x+m yp" : "xm"
    }

    OnReloadLauncherFile(btn, info) {
        this.Close()
        this.app.Launchers.ReloadLauncherFile()
    }

    OnCleanLaunchers(btn, info) {
        this.Close()
        this.app.Builders.CleanLaunchers()
    }

    OnValidateLaunchers(btn, info) {
        this.Close()
        op := ValidateLaunchersOp.new(this.app)
        op.Run()
    }

    OnFlushCache(btn, info) {
        this.Close()
        this.app.Cache.FlushCaches()
    }

    OnUpdateDependencies(btn, info) {
        this.Close()
        this.app.Dependencies.UpdateDependencies(true)
    }

    OnClose(guiObj) {
        this.Close()
        super.OnClose(guiObj)
    }

    OnEscape(guiObj) {
        this.Close()
        super.OnEscape(guiObj)
    }

    OnCheckForUpdates(btn, info) {
        this.app.CheckForUpdates()
    }

    OnOpenWebsite(btn, info) {
        this.app.OpenWebsite()
    }

    OnProvideFeedback(btn, info) {
        this.app.ProvideFeedback()
    }
}
