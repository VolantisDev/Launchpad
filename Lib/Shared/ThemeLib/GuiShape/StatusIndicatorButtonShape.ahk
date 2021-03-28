class StatusIndicatorButtonShape extends ButtonShape {
    RenderContent(w, h) {
        textX := 0
        textY := 0
        textW := w
        textH := h

        if (this.drawConfig.Has("photo") && FileExist(this.drawConfig["photo"])) {
            imgX := 0
            imgY := 0
            imgW := h
            imgH := h
            textX += imgW
            textW -= imgW
            imageBitmap := Gdip_CreateBitmapFromFile(this.drawConfig["photo"])
            Gdip_DrawImage(this.graphics, imageBitmap, imgX, imgY, imgW, imgH)
        }
        textX += 5
        Gdip_TextToGraphics(this.graphics, this.GetButtonText(), this.config["textAlign"] . " vCenter cff" . this.config["textColor"] . " X" . textX . " Y" . textY, this.config["font"], textW, textH)
    }
}
