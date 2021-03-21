class MaximizeSymbol extends GuiSymbolBase {
    DrawSymbol(graphics, x, y, w, h) {
        ; Outline
        Gdip_DrawRectangle(graphics, this.pen, x, y, w, h)

        ; Titlebar
        tbY := y + this.strokeWidth
        tbX1 := x + this.strokeWidth
        tbX2 := tbX1 + w - this.strokeWidth
        Gdip_DrawLine(graphics, this.pen, tbX1, tbY, tbX2, tbY)
    }
}
