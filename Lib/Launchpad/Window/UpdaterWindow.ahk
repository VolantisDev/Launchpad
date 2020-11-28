class MainWindow extends WindowBase {
    contentWidth := 515
    areaW := 430
    row1Height := 80
    row2Height := 30
    logo := ""

    __New(app, owner := "", windowKey := "") {
        this.logo := app.Config.AppDir . "\Graphics\Logo.png"
        super.__New(app, "Launchpad Updater", owner, windowKey)
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
        btn := this.guiObj.AddButton("x" . buttonX . " w" . buttonWidth . " h" . this.row1Height . " Section", "Update &Launchpad")
        btn.OnEvent("Click", "OnUpdateLaunchpad")
        btn := this.guiObj.AddButton("ys wp hp", "Update &Dependencies")
        btn.OnEvent("Click", "OnUpdateDependencies")

        ; Second row
        buttonWidth := this.ButtonWidth(1, this.areaW)
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

    OnUpdateLaunchpad(btn, info) {
        this.app.Installers.UpdateApp()
    }

    OnUpdateDependencies(btn, info) {
        this.app.Installers.UpdateDependencies()
    }
}
