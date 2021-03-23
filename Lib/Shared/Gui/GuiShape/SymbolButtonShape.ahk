class SymbolButtonShape extends ButtonShape {
    margin := 4

    RenderContent(w, h) {
        symbol := this.themeObj.GetSymbol(this.btnText, this.textColor, this.dimColor, this.bgColor, this.strokeWidth)

        if (symbol) {
            x := 0 + this.margin
            y := 0 + this.margin
            symbolW := w - (this.margin * 2)
            symbolH := h - (this.margin * 2)

            symbol.Draw(this.graphics, x, y, symbolW, symbolH)
        }
    }
}