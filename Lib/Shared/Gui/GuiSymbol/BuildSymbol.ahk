class BuildSymbol extends GuiSymbolBase {
    DrawSymbol(graphics, x, y, w, h) {
        ; 3 Boxes


        ; First line of X
        Gdip_DrawLine(graphics, this.pen, x, y, x + w, y+h)

        ; Second line of X
        Gdip_DrawLine(graphics, this.pen, x, y + h, x + w, y)
    }
}
