class LauncherProgressIndicator extends MiniProgressIndicator {
    gif := ""
    gameTitle := ""
    gameIcon := ""

    __New(title, themeObj, gameIcon, windowKey := "", owner := "", parent := "", rangeStop := "", currentPosition := 0, showInNotificationArea := true) {
        this.gameTitle := title
        this.gameIcon := gameIcon
        
        if (windowKey == "") {
            windowKey := "LauncherProgressIndicator"
        }

        super.__New(title, themeObj, "", windowKey, owner, parent, rangeStop, currentPosition, showInNotificationArea)
    }

    Controls() {
        this.SetFont("normal", "bold")
        this.guiObj.AddPicture("w16 h-1 +BackgroundTrans", this.gameIcon)
        this.guiObj.AddText("x+" . this.margin . " yp w" . (this.windowSettings["contentWidth"] - 16 - this.margin), this.gameTitle)
        this.SetFont()

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
        super.Destroy()
    }
}
