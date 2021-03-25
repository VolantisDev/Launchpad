class StatusIndicatorButtonShape extends ButtonShape {
    Draw(w, h) {
        this.bitmap := Gdip_CreateBitmap(w, h)
        this.graphics := Gdip_GraphicsFromImage(this.bitmap)
        Gdip_SetSmoothingMode(this.graphics, 4)

        bgBrush := Gdip_BrushCreateSolid("0xff" . this.config["bgColor"])
        Gdip_FillRectangle(this.graphics, bgBrush, -1, -1, w+2, h+2)
        Gdip_DeleteBrush(bgBrush)

        if (this.config["borderThickness"] > 0) {
            borderPen := Gdip_CreatePen("0xff" . this.config["borderColor"], this.config["borderThickness"])
            Gdip_DrawRectangle(this.graphics, borderPen, 0 + Floor(this.config["borderThickness"] / 2), 0 + Floor(this.config["borderThickness"] / 2), w - this.config["borderThickness"], h - this.config["borderThickness"])
            Gdip_DeletePen(borderPen)
        }
        
        this.RenderContent(w, h)
        this.hBitmap := Gdip_CreateHBITMAPFromBitmap(this.bitmap)
        return this.hBitmap
    }

    RenderContent(w, h) {
        Gdip_TextToGraphics(this.graphics, this.GetButtonText(), this.config["textAlign"] . " vCenter cff" . this.config["textColor"], this.config["font"], w, h)
    }

    Cleanup() {
        Gdip_DeleteGraphics(this.graphics)
        Gdip_DisposeImage(this.bitmap)
        DeleteObject(this.hBitmap)
    }
}
