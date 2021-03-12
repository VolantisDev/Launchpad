class ToolsWindow extends LaunchpadGuiBase {
    positionAtMouseCursor := true
    nextPos := "xm"
    showTitlebar := false

    __New(app, windowKey := "", owner := "", parent := "") {
        super.__New(app, "Tools", windowKey, owner, parent)
        this.onLButtonCallback := ObjBindMethod(this, "OnLButton")
    }

    OnLButton(hotKey) {
        if (this.app && this.app.Windows && this.app.Windows.WindowIsOpen(this.windowKey)) {
            MouseGetPos(,, mouseWindow)
            
            if (this.guiObj && this.guiObj.Hwnd != mouseWindow) {
                this.Close()
            }
        }
    }

    Show() {
        Hotkey("~LButton", this.onLButtonCallback, "On")
        super.Show()
    }

    Destroy() {
        Hotkey("~LButton", this.onLButtonCallback, "Off")
        super.Destroy()
    }

    Controls() {
        super.Controls()
        this.guiObj.BackColor := this.themeObj.GetColor("accentDark")
        this.AddToolButton("&Detect Games", "DetectGames")
        this.AddToolButton("&Reload Launchers", "ReloadLaunchers")
        this.AddToolButton("&Clean Launchers", "CleanLaunchers")
        ;this.AddToolButton("&Validate Launchers", "ValidateLaunchers")
        this.AddToolButton("&Flush Cache", "FlushCache")
        ;this.AddToolButton("&Update Launchpad", "CheckForUpdates")
        ;this.AddToolButton("Update &Dependencies", "UpdateDependencies")
        this.AddToolButton("&Open Website", "OpenWebsite")
        this.AddToolButton("Provide &Feedback", "ProvideFeedback")
        this.AddToolButton("&About Launchpad", "AboutLaunchpad")
    }

    AddToolButton(buttonLabel, ctlName) {
        width := (this.windowSettings["contentWidth"] - this.margin) / 2

        buttonSize := this.themeObj.GetButtonSize("l")
        buttonH := (buttonSize.Has("h") && buttonSize["h"] != "auto") ? buttonSize["h"] : 40

        btn := this.AddButton("v" . ctlName . " " . this.nextPos . " w" . width . " h" . buttonH, buttonLabel)
        this.nextPos := this.nextPos == "xm" ? "x+m yp" : "xm"
    }

    OnDetectGames(btn, info) {
        this.Close()
        this.app.Platforms.DetectGames()
    }

    OnReloadLaunchers(btn, info) {
        this.Close()
        this.app.Launchers.LoadComponents(this.app.Config.LauncherFile)

        if (this.app.Windows.WindowIsOpen("ManageWindow")) {
            this.app.Windows.GetItem("ManageWindow").PopulateListView()
        }
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
        this.app.Installers.UpdateDependencies()
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
        this.Close()
        this.app.CheckForUpdates()
    }

    OnOpenWebsite(btn, info) {
        this.Close()
        this.app.OpenWebsite()
    }

    OnProvideFeedback(btn, info) {
        this.Close()
        this.app.ProvideFeedback()
    }

    OnAboutLaunchpad(btn, info) {
        this.Close()
        this.app.Windows.AboutWindow()
    }
}
