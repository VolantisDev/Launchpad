class GuiSymbolBase {
    strokeColor := ""
    strokeWidth := ""
    pen := ""
    
    __New(strokeColor, strokeWidth) {
        this.strokeColor := strokeColor
        this.strokeWidth := strokeWidth
        this.pen := this.CreatePen()
    }

    CreatePen() {
        return Gdip_CreatePen("0xff" . this.strokeColor, this.strokeWidth)
    }

    __Delete() {
        if (this.pen) {
            Gdip_DeletePen(this.pen)
        }
        
        super.__Delete()
    }

    

    Draw(graphics, x, y, w, h) {
        try {
            this.DrawSymbol(graphics, x, y, w, h)
        } catch ex {
            MsgBox(ex.Where . ": " . ex.Message)
        }
    }

    DrawSymbol(graphics, x, y, w, h) {
        MethodNotImplementedException.new("GuiSymbolBase", "DrawOn")
    }
}
