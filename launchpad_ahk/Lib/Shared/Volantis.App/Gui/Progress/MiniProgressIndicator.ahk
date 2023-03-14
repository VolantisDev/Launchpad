class MiniProgressIndicator extends ProgressIndicatorBase {
    gif := ""

    Controls() {
        if (this.config["text"] != "") {
            this.guiObj.AddText("w" . this.windowSettings["contentWidth"] . "", this.config["text"])
        }

        this.AddGuiProgressIndicator()

        this.SetFont("small")
        w := this.windowSettings["contentWidth"]

        if (this.config["showStatusIndicator"]) {
            w -= 60
        }

        this.guiObj.AddText("x" . this.margin . " w" . w . " vDialogDetailText", this.detailText)
        
        if (this.config["showStatusIndicator"]) {
            this.guiObj.AddText("x" . (this.windowSettings["contentWidth"] - 50) . " yp w50 Right vDialogStatusIndicator", this.currentPosition . " / " . this.rangeStop)
        }
        
        this.SetFont()
    }

    AddGuiProgressIndicator() {
        spinner := this.themeObj.GetThemeAsset("spinner")
        
        ;this.guiObj.AddActiveX("x" . this.margin . " w40 h40", "mshtml:<img src='" . spinner . "' />")
        ;dllPath := this.themeObj.resourcesDir . "\Dependencies\AniGIF.dll"
        ;this.gif := AnimatedGif(this.guiObj, dllPath, "x" . this.margin . " w40 h40", spinner)
        ;this.gif.SetBkColor("White")
    }

    Destroy() {
        ;this.gif.UnloadGif()
        super.Destroy()
    }
}
