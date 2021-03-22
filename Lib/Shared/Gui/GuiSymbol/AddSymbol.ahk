class AddSymbol extends GuiSymbolBase {
    DrawSymbol(graphics, x, y, w, h) {
        offset := this.strokeWidth > 1 ? (this.strokeWidth / 4) : 0
        offset := 0.25 ; @todo Why does this look better?

        symbolMargin := 2

        x += symbolMargin
        y += symbolMargin
        w -= symbolMargin*2
        h -= symbolMargin*2

        vX1 := x + (w/2) - offset
        vY1 := y
        vX2 := vX1
        vY2 := y + h

        hX1 := x
        hY1 := y + (h/2) - offset
        hX2 := x + w
        hY2 := hY1

        ; First line of X
        Gdip_DrawLine(graphics, this.pen, vX1, vY1, vX2, vY2)

        ; Second line of X
        Gdip_DrawLine(graphics, this.pen, hX1, hY1, hX2, hY2)
    }
}
