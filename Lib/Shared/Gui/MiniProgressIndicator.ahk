class MiniProgressIndicator extends ProgressIndicatorBase {
    gif := ""

    __New(title, themeObj, text, windowKey := "", owner := "", parent := "", rangeStop := "", currentPosition := 0, showInNotificationArea := true) {
        ; @todo display text somewhere?

        if (windowKey == "") {
            windowKey := "MiniProgressIndicator"
        }

        super.__New(title, themeObj, "", windowKey, owner, parent, "", rangeStop, currentPosition, true, showInNotificationArea)
    }

    Controls() {
        if (this.text != "") {
            this.guiObj.AddText("w" . this.windowSettings["contentWidth"] . "", this.text)
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
