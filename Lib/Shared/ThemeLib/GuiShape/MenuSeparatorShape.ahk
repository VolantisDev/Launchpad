class MenuSeparatorShape extends ButtonShape {
    RenderContent(w, h) {
        pen := Gdip_CreatePen("0xff" . this.config["dimColor"], 1)
        y := Floor(h/2)
        Gdip_DrawLine(this.graphics, pen, 0, y, w, y)
        Gdip_DeletePen(pen)
    }
}
