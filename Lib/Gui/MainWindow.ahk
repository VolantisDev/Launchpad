class MainWindow extends GuiBase {
    windowSize := "w535"
    contentWidth := 515
    areaW := 430
    row1Height := 80
    row2Height := 30
    logo := ""

    __New(app, title, owner := "", windowKey := "") {
        this.logo := app.AppConfig.AppDir . "\Graphics\Logo.png"
        super.__New(app, title, owner, windowKey)
    }

    GetTitle(title) {
        return title
    }

    Controls() {
        super.Controls()

        this.guiObj.marginX := this.margin
        this.guiObj.marginY := this.margin * 3

        img := this.guiObj.AddPicture("w" . this.contentWidth . " h-1 +BackgroundTrans", this.logo)
        img.OnEvent("Click", "OnLogo")

        buttonX := this.margin + ((this.contentWidth - this.areaW) / 2)

        ; First row
        buttonWidth := this.ButtonWidth(2, this.areaW)
        btn := this.guiObj.AddButton("x" . buttonX . " w" . buttonWidth . " h" . this.row1Height . " Section", "&Manage Launchers")
        btn.OnEvent("Click", "OnManageLaunchers")
        btn := this.guiObj.AddButton("ys wp hp", "&Build Launchers")
        btn.OnEvent("Click", "OnBuildLaunchers")

        ; Second row
        buttonWidth := this.ButtonWidth(3, this.areaW)
        btn := this.guiObj.AddButton("x" . buttonX . " y+" . this.margin . " w" . buttonWidth . " h" . this.row2Height . " Section", "&Tools")
        btn.OnEvent("Click", "OnTools")
        btn := this.guiObj.AddButton("ys wp hp", "&Settings")
        btn.OnEvent("Click", "OnSettings")
        btn := this.guiObj.AddButton("ys wp hp", "&Exit")
        btn.OnEvent("Click", "OnClose")
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
        this.app.BuildLaunchers(this.app.AppConfig.UpdateExistingLaunchers)
    }

    OnManageLaunchers(btn, info) {
        this.app.GuiManager.OpenLauncherManager()
    }

    OnTools(btn, info) {
        this.app.GuiManager.OpenToolsWindow()
    }

    OnSettings(btn, info) {
        this.app.GuiManager.OpenSettingsWindow()
    }
}
