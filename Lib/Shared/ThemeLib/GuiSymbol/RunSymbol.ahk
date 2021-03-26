class RunSymbol extends GuiSymbolBase {
    DrawSymbol(graphics, x, y, w, h) {
        ; First line of X
        Gdip_DrawLine(graphics, this.pen, x, y, x + w, y+h)

        ; Second line of X
        Gdip_DrawLine(graphics, this.pen, x, y + h, x + w, y)
    }
}
