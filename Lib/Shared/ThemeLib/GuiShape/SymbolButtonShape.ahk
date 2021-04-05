class SymbolButtonShape extends ButtonShape {
    margin := 4

    RenderContent(w, h) {
        symbol := this.themeObj.GetSymbol(this.btnText, this.config)

        text := (this.drawConfig.Has("text") && this.drawConfig["text"]) ? this.drawConfig["text"] : ""

        textX := 0
        textW := w

        if (symbol) {
            x := 0 + this.config["margin"]
            y := 0 + this.config["margin"]
            symbolH := h - (this.config["margin"] * 2)
            symbolW := symbolH
            symbol.Draw(this.graphics, x, y, symbolW, symbolH)

            textX += symbolW + (this.config["margin"]*4)
            textW := w - textX
        }

        if (text) {
            if (this.config["textUpper"]) {
                text := StrUpper(text)
            }

            Gdip_TextToGraphics(this.graphics, text, this.config["textAlign"] . " X" . textX . " W" . textW . " vCenter cff" . this.config["textColor"], this.config["font"], textW, h)
        }
    }
}
