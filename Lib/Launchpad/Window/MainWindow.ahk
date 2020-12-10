class MainWindow extends LaunchpadGuiBase {
    buttonAreaRatio := 0.8

    GetTitle(title) {
        return title
    }

    Controls() {
        super.Controls()

        this.guiObj.marginX := this.margin
        this.guiObj.marginY := this.margin * 3

        img := this.guiObj.AddPicture("w" . this.windowSettings["contentWidth"] . " h-1 +BackgroundTrans", this.themeObj.GetThemeAsset("logo"))
        img.OnEvent("Click", "OnLogo")

        areaW := this.windowSettings["contentWidth"] * this.buttonAreaRatio
        buttonX := this.margin + ((this.windowSettings["contentWidth"] - areaW) / 2)
        hugeButtonSize := this.themeObj.GetButtonSize("xl")
        hugeButtonH := hugeButtonSize.Has("h") ? hugeButtonSize["h"] : 80
        normalButtonSize := this.themeObj.GetButtonSize("m")
        normalButtonH := normalButtonSize.Has("h") ? normalButtonSize["h"] : 30

        ; First row
        buttonWidth := this.ButtonWidth(2, areaW)
        btn := this.AddButton("x" . buttonX . " w" . buttonWidth . " h" . hugeButtonH . " Section vManageLaunchers", "&Manage Launchers")
        btn := this.AddButton("ys wp hp vBuildLaunchers", "&Build Launchers")

        ; Second row
        buttonWidth := this.ButtonWidth(3, areaW)
        btn := this.AddButton("x" . buttonX . " y+" . this.margin . " w" . buttonWidth . " h" . normalButtonH . " Section vTools", "&Tools")
        btn := this.AddButton("ys wp hp vSettings", "&Settings")
        btn := this.AddButton("ys wp hp vClose", "&Exit")
    }

    OnClose(guiObj, info := "") {
        super.OnClose(guiObj)
        this.app.ExitApp()
    }

    OnEscape(guiObj) {
        super.OnEscape(guiObj)
        this.app.ExitApp()
    }

    OnLogo(img, info) {
        
    }

    OnBuildLaunchers(btn, info) {
        this.app.Builders.BuildLaunchers(this.app.Launchers.Launchers, this.app.Config.RebuildExistingLaunchers)
    }

    OnManageLaunchers(btn, info) {
        this.app.Windows.OpenManageWindow()
    }

    OnTools(btn, info) {
        this.app.Windows.OpenToolsWindow()
    }

    OnSettings(btn, info) {
        this.app.Windows.OpenSettingsWindow()
    }
}
