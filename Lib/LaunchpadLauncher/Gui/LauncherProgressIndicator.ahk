class LauncherProgressIndicator extends MiniProgressIndicator {
    gif := ""
    hasStatusIndicator := false

    __New(app, themeObj, windowKey, title, gameIcon, owner := "", parent := "", rangeStop := "", currentPosition := 0, showInNotificationArea := true) {
        this.gameTitle := title
        if (windowKey == "") {
            windowKey := "LauncherProgressIndicator"
        }

        super.__New(app, themeObj, windowKey, title, "", owner, parent, rangeStop, currentPosition, showInNotificationArea)
        this.iconSrc := gameIcon
    }

    GetTitle(title) {
        return this.app.appName
    }

    Controls() {
        if (this.text != "") {
            this.guiObj.AddText("x" . this.margin . " w" . this.windowSettings["contentWidth"] . "", this.text)
        }

        this.AddGuiProgressIndicator()

        this.SetFont("small")
        this.guiObj.AddText("x" . this.margin . " w" . this.windowSettings["contentWidth"] . " vDialogDetailText", this.detailText)
        ;this.guiObj.AddText("x" . (this.windowSettings["contentWidth"] - 50) . " yp w50 Right vDialogStatusIndicator", this.currentPosition . " / " . this.rangeStop)
        this.SetFont()
    }

    AddGuiProgressIndicator() {
        spinner := this.themeObj.GetThemeAsset("spinner")
        ; TODO: Get spinner working
        ;this.guiObj.AddActiveX("x" . this.margin . " w40 h40", "mshtml:<img src='" . spinner . "' />")
        ;dllPath := this.themeObj.resourcesDir . "\Dependencies\AniGIF.dll"
        ;this.gif := AnimatedGif(this.guiObj, dllPath, "x" . this.margin . " w40 h40", spinner)
        ;this.gif.SetBkColor("White")
    }

    Destroy() {
        ;this.gif.UnloadGif()
        this.app.ExitApp()
        super.Destroy()
    }
}
