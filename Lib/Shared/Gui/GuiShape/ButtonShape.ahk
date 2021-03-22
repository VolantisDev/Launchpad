class ButtonShape extends GuiShapeBase {
    themeObj := ""
    btnText := ""
    bgColor := ""
    textColor := ""
    dimColor := ""
    borderColor := ""
    borderThickness := ""
    font := "Arial"
    graphics := ""
    bitmap := ""
    hbitmap := ""
    strokeWidth := ""

    __New(themeObj, btnText, bgColor, textColor, dimColor, borderColor, borderThickness := 1, strokeWidth := 1) {
        this.themeObj := themeObj
        this.btnText := btnText
        this.bgColor := bgColor
        this.textColor := textColor
        this.borderColor := borderColor
        this.borderThickness := borderThickness
        this.strokeWidth := strokeWidth
        this.dimColor := dimColor
    }

    Draw(w, h) {
        this.bitmap := Gdip_CreateBitmap(w, h)
        this.graphics := Gdip_GraphicsFromImage(this.bitmap)
        Gdip_SetSmoothingMode(this.graphics, 4)

        bgBrush := Gdip_BrushCreateSolid("0xff" . this.bgColor)
        Gdip_FillRectangle(this.graphics, bgBrush, -1, -1, w+2, h+2)
        Gdip_DeleteBrush(bgBrush)

        if (this.borderThickness > 0) {
            borderPen := Gdip_CreatePen("0xff" . this.borderColor, this.borderThickness)
            Gdip_DrawRectangle(this.graphics, borderPen, 0 + Floor(this.borderThickness / 2), 0 + Floor(this.borderThickness / 2), w - this.borderThickness, h - this.borderThickness)
            Gdip_DeletePen(borderPen)
        }
        
        this.RenderContent(w, h)
        this.hBitmap := Gdip_CreateHBITMAPFromBitmap(this.bitmap)
        return this.hBitmap
    }

    RenderContent(w, h) {
        Gdip_TextToGraphics(this.graphics, this.GetButtonText(), "Center vCenter cff" . this.textColor, this.font, w, h)
    }

    Cleanup() {
        Gdip_DeleteGraphics(this.graphics)
        Gdip_DisposeImage(this.bitmap)
        DeleteObject(this.hBitmap)
    }

    DrawOver(guiControl, guiObj) {
        guiControl.GetPos(x, y, w, h)

        guiControl.Opt("Hidden")
        position := "x" . x . " y" . y . " w" . w . " h" . h
        picObj := guiObj.AddPicture(position . " 0xE")

        if (guiControl.Name != "") {
            picObj.OnEvent("Click", "On" . guiControl.Name)
        }

        return this.DrawOn(picObj)
    }

    DrawOn(guiControl) {
        guiControl.GetPos(,, w, h)
        SetImage(guiControl.Hwnd, this.Draw(w, h))
        return guiControl
    }

    __Delete() {
        this.Cleanup()
        super.__Delete()
    }

    GetButtonText() {
        btnText := this.btnText

        return StrReplace(btnText, "&", "")
    }
}
