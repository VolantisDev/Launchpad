class MaximizeSymbol extends GuiSymbolBase {
    DrawSymbol(graphics, x, y, w, h) {
        ; Outline
        Gdip_DrawRectangle(graphics, this.pen, x, y, w, h)

        ; Titlebar
        tbY := y + this.config["strokeWidth"]
        tbX1 := x + this.config["strokeWidth"]
        tbX2 := tbX1 + w - this.config["strokeWidth"]
        Gdip_DrawLine(graphics, this.pen, tbX1, tbY, tbX2, tbY)
    }
}
