class MinimizeSymbol extends GuiSymbolBase {
    DrawSymbol(graphics, x, y, w, h) {
        ; Bottom line
        tbY := y + h
        Gdip_DrawLine(graphics, this.pen, x, tbY, x + w, tbY)
    }
}
