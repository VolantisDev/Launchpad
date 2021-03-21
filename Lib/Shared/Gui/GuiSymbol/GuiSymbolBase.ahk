class GuiSymbolBase {
    strokeColor := ""
    dimColor := ""
    strokeWidth := ""
    bgColor := ""
    pen := ""
    dimPen := ""
    margin := 2
    
    __New(strokeColor, strokeWidth, dimColor, bgColor) {
        this.strokeColor := strokeColor
        this.strokeWidth := strokeWidth
        this.dimColor := dimColor
        this.bgColor := bgColor
        this.pen := this.CreatePen(this.strokeColor)
        this.dimPen := this.CreatePen(this.dimColor)
    }

    CreatePen(colorVal) {
        return Gdip_CreatePen("0xff" . colorVal, this.strokeWidth)
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
        
        super.__Delete()
    }

    Draw(graphics, x, y, w, h) {
        try {
            this.DrawSymbol(graphics, x, y, w, h)
        } catch ex {
            throw ex
        }
    }

    DrawSymbol(graphics, x, y, w, h) {
        MethodNotImplementedException.new("GuiSymbolBase", "DrawOn")
    }
}
