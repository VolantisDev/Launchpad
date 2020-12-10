class UpdaterWindow extends LaunchpadGuiBase {
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
        btn := this.guiObj.AddButton("x" . buttonX . " w" . buttonWidth . " h" . hugeButtonH . " Section", "Update &Launchpad")
        this.buttons.Push(btn)
        btn.OnEvent("Click", "OnUpdateLaunchpad")
        btn := this.guiObj.AddButton("ys wp hp", "Update &Dependencies")
        this.buttons.Push(btn)
        btn.OnEvent("Click", "OnUpdateDependencies")

        ; Second row
        buttonWidth := this.ButtonWidth(1, areaW)
        btn := this.guiObj.AddButton("x" . buttonX . " y+" . this.margin . " w" . buttonWidth . " h" . normalButtonH . " Section", "&Exit")
        this.buttons.Push(btn)
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
        this.app.Installers.UpdateApp("UpdateWindow")
    }

    OnUpdateDependencies(btn, info) {
        this.app.Installers.UpdateDependencies("UpdateWindow")
    }
}
