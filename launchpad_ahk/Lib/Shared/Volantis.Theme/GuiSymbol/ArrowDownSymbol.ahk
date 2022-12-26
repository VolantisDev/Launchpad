class ArrowDownSymbol extends GuiSymbolBase {
    DrawSymbol(graphics, x, y, w, h) {
        if (w/2) != (Floor(w/2)) {
            w -= 1
        }

        margin := 1
        topL := (x + margin*2) . "," . (y + margin*4)
        topR := (x + w - (margin*4)) . "," . (y + margin*4)
        point := x + (w/2) . "," . (y + h - (margin*8))
        points := topL . "|" . topR . "|" . point
        Gdip_FillPolygon(graphics, this.fgBrush, points)
    }
}
