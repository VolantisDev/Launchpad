class UnmaximizeSymbol extends GuiSymbolBase {
    DrawSymbol(graphics, x, y, w, h) {
        oX := x + this.margin
        oY := y
        oW := w - this.margin
        oH := h - this.margin
        ; Outline
        Gdip_DrawRectangle(graphics, this.dimPen, oX, oY, oW, oH)

        wX := x
        wY := y + this.margin
        wW := w - this.margin
        wH := h - this.margin

        ; Window background
        brush := this.CreateBrush(this.bgColor)
        Gdip_FillRectangle(graphics, brush, wX, wY, wW, wH)
        Gdip_DeleteBrush(brush)

        ; Window outline
        
        Gdip_DrawRectangle(graphics, this.pen, x, wY, wW, wH)

        ; Titlebar
        tbY := wY + this.strokeWidth
        tbX1 := x + this.strokeWidth
        tbX2 := tbX1 + wW - this.strokeWidth
        Gdip_DrawLine(graphics, this.pen, tbX1, tbY, tbX2, tbY)
    }
}
