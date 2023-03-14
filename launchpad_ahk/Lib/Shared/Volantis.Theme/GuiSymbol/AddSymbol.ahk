class AddSymbol extends GuiSymbolBase {
    DrawSymbol(graphics, x, y, w, h) {
        offset := this.config["strokeWidth"] > 1 ? (this.config["strokeWidth"] / 4) : 0
        ; TODO: Determine why this value seems to work
        offset := 0.25

        symbolMargin := h/5

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
