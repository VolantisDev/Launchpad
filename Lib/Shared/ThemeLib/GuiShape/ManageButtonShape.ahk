class ManageButtonShape extends SymbolButtonShape {
    margin := 4

    DrawBorder(borderPen, w, h) {
        w := h
        Gdip_DrawRectangle(this.graphics, borderPen, 0 + Floor(this.config["borderThickness"] / 2), 0 + Floor(this.config["borderThickness"] / 2), w - this.config["borderThickness"], h - this.config["borderThickness"])
        Gdip_DeletePen(borderPen)
    }
}
