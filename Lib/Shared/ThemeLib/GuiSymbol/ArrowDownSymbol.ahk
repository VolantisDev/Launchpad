class ArrowDownSymbol extends GuiSymbolBase {
    DrawSymbol(graphics, x, y, w, h) {
        margin := this.config["margin"]*2
        topL := (x + margin) . "," . (y + margin*1.5)
        topR := (x+w - (margin*2)) . "," . (y + margin*1.5)
        point := x + (w/2) . "," . (y + h - (margin*3))
        points := topL . "|" . topR . "|" . point
        Gdip_FillPolygon(graphics, this.fgBrush, points)
    }
}
