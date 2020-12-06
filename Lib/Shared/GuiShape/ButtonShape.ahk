class ButtonShape extends GuiShapeBase {
    btnText := ""
    bgColor := ""
    textColor := ""
    borderColor := ""
    borderThickness := ""
    font := "Arial"

    __New(btnText, bgColor, textColor, borderColor, borderThickness := 2) {
        this.btnText := btnText
        this.bgColor := bgColor
        this.textColor := textColor
        this.borderColor := borderColor
        this.borderThickness := borderThickness
    }

    DrawOver(guiControl, guiObj) {
        guiControl.GetPos(x, y, w, h)

        guiControl.Opt("Hidden")
        position := "x" . x . " y" . y . " w" . w . " h" . h
        picObj := guiObj.AddPicture(position . " 0xE")
        if (guiControl.Name != "") {
            picObj.OnEvent("Click", "On" . guiControl.Name)
        }

        bitmap := Gdip_CreateBitmap(w, h)
        graphics := Gdip_GraphicsFromImage(bitmap)
        Gdip_SetSmoothingMode(graphics, 4)

        bgBrush := Gdip_BrushCreateSolid("0xff" . this.bgColor)
        Gdip_FillRectangle(graphics, bgBrush, 0, 0, w, h)
        Gdip_DeleteBrush(bgBrush)

        borderPen := Gdip_CreatePen("0xff" . this.borderColor, this.borderThickness)
        Gdip_DrawRectangle(graphics, borderPen, 0 + Floor(this.borderThickness / 2), 0 + Floor(this.borderThickness / 2), w - this.borderThickness, h - this.borderThickness)
        Gdip_DeletePen(borderPen)

        Gdip_TextToGraphics(graphics, this.GetButtonText(), "Center vCenter cff" . this.textColor, this.font, w, h)

        hBitmap := Gdip_CreateHBITMAPFromBitmap(bitmap)
        SetImage(picObj.Hwnd, hBitmap)

        Gdip_DeleteGraphics(graphics)
        Gdip_DisposeImage(bitmap)
        DeleteObject(hBitmap)

        return true
    }

    GetButtonText() {
        btnText := this.btnText

        return StrReplace(btnText, "&", "")
    }
}
