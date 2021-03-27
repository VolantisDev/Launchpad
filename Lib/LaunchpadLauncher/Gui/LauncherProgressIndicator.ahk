class LauncherProgressIndicator extends MiniProgressIndicator {
    gif := ""

    __New(app, themeObj, windowKey, title, gameIcon, owner := "", parent := "", rangeStop := "", currentPosition := 0, showInNotificationArea := true) {
        this.gameTitle := title
        
        if (windowKey == "") {
            windowKey := "LauncherProgressIndicator"
        }

        super.__New(app, themeObj, windowKey, title, "", owner, parent, rangeStop, currentPosition, showInNotificationArea)

        this.iconSrc := gameIcon ; @todo refactor so this is passed in to the parent constructor
    }

    Controls() {
        if (this.text != "") {
            this.guiObj.AddText("x" . this.margin . " w" . this.windowSettings["contentWidth"] . "", this.text)
        }

        this.AddGuiProgressIndicator()

        this.SetFont("small")
        this.guiObj.AddText("x" . this.margin . " w" . (this.windowSettings["contentWidth"] - 60) . " vDialogDetailText", this.detailText)
        this.guiObj.AddText("x" . (this.windowSettings["contentWidth"] - 50) . " yp w50 Right vDialogStatusIndicator", this.currentPosition . " / " . this.rangeStop)
        this.SetFont()
    }

    AddGuiProgressIndicator() {
        spinner := this.themeObj.GetThemeAsset("spinner")
        
        ;this.guiObj.AddActiveX("x" . this.margin . " w40 h40", "mshtml:<img src='" . spinner . "' />")
        ;dllPath := this.themeObj.resourcesDir . "\Dependencies\AniGIF.dll"
        ;this.gif := AnimatedGif.new(this.guiObj, dllPath, "x" . this.margin . " w40 h40", spinner)
        ;this.gif.SetBkColor("White")
    }

    Destroy() {
        ;this.gif.UnloadGif()
        this.app.ExitApp()
        super.Destroy()
    }
}
