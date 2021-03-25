class SymbolButtonShape extends ButtonShape {
    margin := 4

    RenderContent(w, h) {
        symbol := this.themeObj.GetSymbol(this.btnText, this.config)

        if (symbol) {
            x := 0 + this.config["margin"]
            y := 0 + this.config["margin"]
            symbolW := w - (this.config["margin"] * 2)
            symbolH := h - (this.config["margin"] * 2)

            symbol.Draw(this.graphics, x, y, symbolW, symbolH)
        }
    }
}
