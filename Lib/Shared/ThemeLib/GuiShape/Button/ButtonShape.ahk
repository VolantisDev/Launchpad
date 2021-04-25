class ButtonShape extends GuiShapeBase {
    themeObj := ""
    btnText := ""
    graphics := ""
    bitmap := ""
    hbitmap := ""
    drawConfig := Map()

    config := ""
    defaults := Map("bgColor", "000000", "textColor", "FFFFFF", "dimColor", "EEEEEE", "borderColor", "EEEEEE", "borderThickness", 1, "font", "Arial", "strokeWidth", 1, "textAlign", "Center", "margin", 1)

    __New(themeObj, btnText, config, drawConfig := "") {
        this.themeObj := themeObj
        this.btnText := btnText
        this.config := this.MergeDefaults(config)
        
        if (drawConfig) {
            this.drawConfig := drawConfig
        }
    }

    MergeDefaults(config) {
        for key, value in this.defaults {
            if (!config.Has(key)) {
                config[key] := value
            }
        }

        return config
    }

    Draw(w, h) {
        this.bitmap := Gdip_CreateBitmap(w, h)
        this.graphics := Gdip_GraphicsFromImage(this.bitmap)
        Gdip_SetSmoothingMode(this.graphics, 4)

        bgBrush := Gdip_BrushCreateSolid("0xff" . this.config["bgColor"])
        Gdip_FillRectangle(this.graphics, bgBrush, -1, -1, w+2, h+2)
        Gdip_DeleteBrush(bgBrush)

        if (this.config["borderThickness"] > 0) {
            borderPen := Gdip_CreatePen("0xff" . this.config["borderColor"], this.config["borderThickness"])
            this.DrawBorder(borderPen, w, h)
        }
        
        this.RenderContent(w, h)
        this.hBitmap := Gdip_CreateHBITMAPFromBitmap(this.bitmap)
        return this.hBitmap
    }

    DrawBorder(borderPen, w, h) {
        Gdip_DrawRectangle(this.graphics, borderPen, 0 + Floor(this.config["borderThickness"] / 2), 0 + Floor(this.config["borderThickness"] / 2), w - this.config["borderThickness"], h - this.config["borderThickness"])
        Gdip_DeletePen(borderPen)
    }

    RenderContent(w, h) {
        x := "X5"
        textW := w - 8
        buttonText := this.GetButtonText()

        if (this.config["textUpper"]) {
            buttonText := StrUpper(buttonText)
        }

        Gdip_TextToGraphics(this.graphics, buttonText, this.config["textAlign"] . " " . x . " W" . textW . " vCenter cff" . this.config["textColor"], this.config["font"], w, h)
    }

    Cleanup() {
        Gdip_DeleteGraphics(this.graphics)
        Gdip_DisposeImage(this.bitmap)
        DeleteObject(this.hBitmap)
    }

    DrawOver(guiControl, guiObj) {
        guiControl.GetPos(&x, &y, &w, &h)

        guiControl.Opt("Hidden")
        position := "x" . x . " y" . y . " w" . w . " h" . h
        picObj := guiObj.AddPicture(position . " 0xE")

        if (guiControl.Name != "") {
            picObj.OnEvent("Click", "On" . guiControl.Name)
        }

        return this.DrawOn(picObj)
    }

    DrawOn(guiControl) {
        guiControl.GetPos(,, &w, &h)
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
