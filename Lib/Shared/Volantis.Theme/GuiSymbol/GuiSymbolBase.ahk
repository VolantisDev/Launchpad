class GuiSymbolBase {
    textColor := ""
    dimColor := ""
    strokeWidth := ""
    bgColor := ""
    pen := ""
    fgBrush := ""
    bgBrush := ""
    dimPen := ""
    margin := 2

    config := ""
    defaults := Map("textColor", "000000", "dimColor", "EEEEEE", "strokeWidth", 1, "bgColor", "000000", "margin", 2)
    
    __New(config) {
        this.config := this.MergeDefaults(config)
        this.pen := this.CreatePen(this.config["textColor"])
        this.fgBrush := this.CreateBrush(this.config["textColor"])
        this.bgBrush := this.CreateBrush(this.config["bgColor"])
        this.dimPen := this.CreatePen(this.config["dimColor"])
    }

    MergeDefaults(config) {
        for key, value in this.defaults {
            if (!config.Has(key)) {
                config[key] := value
            }
        }

        return config
    }

    CreatePen(colorVal) {
        return Gdip_CreatePen("0xff" . colorVal, this.config["strokeWidth"])
    }
    
    CreateBrush(colorVal) {
        return Gdip_BrushCreateSolid("0xff" . colorVal)
    }

    __Delete() {
        if (this.pen) {
            Gdip_DeletePen(this.pen)
        }

        if (this.dimPen) {
            Gdip_DeletePen(this.dimPen)
        }

        if (this.fgBrush) {
            Gdip_DeleteBrush(this.fgBrush)
        }

        if (this.bgBrush) {
            Gdip_DeleteBrush(this.bgBrush)
        }
        
        super.__Delete()
    }

    Draw(graphics, x, y, w, h) {
        try {
            this.DrawSymbol(graphics, x, y, w, h)
        } catch as ex {
            throw ex
        }
    }

    DrawSymbol(graphics, x, y, w, h) {
        MethodNotImplementedException("GuiSymbolBase", "DrawOn")
    }
}
