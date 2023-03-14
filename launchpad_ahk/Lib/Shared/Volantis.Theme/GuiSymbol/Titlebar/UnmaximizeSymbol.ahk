class UnmaximizeSymbol extends GuiSymbolBase {
    innerMargin := 2

    DrawSymbol(graphics, x, y, w, h) {
        oX := x + this.innerMargin
        oY := y
        oW := w - this.innerMargin
        oH := h - this.innerMargin
        ; Outline
        Gdip_DrawRectangle(graphics, this.dimPen, oX, oY, oW, oH)

        wX := x
        wY := y + this.innerMargin
        wW := w - this.innerMargin
        wH := h - this.innerMargin

        ; Window background
        Gdip_FillRectangle(graphics, this.bgBrush, wX, wY, wW, wH)

        ; Window outline
        
        Gdip_DrawRectangle(graphics, this.pen, x, wY, wW, wH)

        ; Titlebar
        tbY := wY + this.config["strokeWidth"]
        tbX1 := x + this.config["strokeWidth"]
        tbX2 := tbX1 + wW - this.config["strokeWidth"]
        Gdip_DrawLine(graphics, this.pen, tbX1, tbY, tbX2, tbY)
    }
}
