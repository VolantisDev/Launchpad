#Include GuiBase.ahk

class MainWindow extends GuiBase {
    windowSize := "w535"
    contentWidth := 515

    GetTitle() {
        return this.title
    }

    Controls(posY) {
        this.guiObj.marginX := this.margin
        this.guiObj.marginY := this.margin * 3

        posY := super.Controls(posY)

        logo := this.app.AppConfig.AppDir . "\Graphics\Logo.png"
        img := this.guiObj.AddPicture("x" . this.margin . " y" . posY . " w" . this.contentWidth . " h-1 +BackgroundTrans", logo)
        img.OnEvent("Click", "OnLogo")
        posY += 205 + this.margin

        areaW := 430
        areaX := this.margin + ((this.contentWidth - areaW) / 2)

        buttonWidth := this.ButtonWidth(2, areaW)
        buttonHeight := 80
        posX := areaX
        btn := this.guiObj.AddButton("x" . posX . " y" . posY . " w" . buttonWidth . " h" . buttonHeight, "&Manage Launchers")
        btn.OnEvent("Click", "OnManageLaunchers")
        posX += buttonWidth + this.margin
        btn := this.guiObj.AddButton("x" . posX . " y" . posY . " w" . buttonWidth . " h" . buttonHeight, "&Build Launchers")
        btn.OnEvent("Click", "OnBuildLaunchers")
        posY += buttonHeight + this.margin

        buttonWidth := this.ButtonWidth(3, areaW)
        buttonHeight := 30
        posX := areaX
        btn := this.guiObj.AddButton("x" . posX . " y" . posY . " w" . buttonWidth . " h" . buttonHeight, "&Tools")
        btn.OnEvent("Click", "OnTools")
        posX += buttonWidth + this.margin
        btn := this.guiObj.AddButton("x" . posX . " y" . posY . " w" . buttonWidth . " h" . buttonHeight, "&Settings")
        btn.OnEvent("Click", "OnSettings")
        posX += buttonWidth + this.margin
        btn := this.guiObj.AddButton("x" . posX . " y" . posY . " w" . buttonWidth . " h" . buttonHeight, "&Exit")
        btn.OnEvent("Click", "OnClose")
        posY += buttonHeight + (this.margin * 3)

        return posY
    }

    OnClose(guiObj) {
        super.OnClose(guiObj)
        this.app.ExitApp()
    }

    OnEscape(guiObj) {
        super.OnEscape(guiObj)
        this.app.ExitApp()
    }

    OnLogo(img) {
        this.app.OpenHomepage()
    }

    OnBuildLaunchers(btn) {
        this.app.BuildLaunchers(this.app.AppConfig.UpdateExistingLaunchers)
    }

    OnManageLaunchers(btn) {
        this.app.Guis.OpenLauncherManager()
    }

    OnTools(btn) {
        this.app.Guis.OpenToolsWindow()
    }

    OnSettings(btn) {
        this.app.Guis.OpenSettingsWindow()
    }
}
