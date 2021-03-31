class MainMenuButtonShape extends ButtonShape {
    margin := 4

    RenderContent(w, h) {
        symbolMargin := 2
        symbolH := h - (symbolMargin*2)
        x := "X" . this.config["margin"]*4
        maxTextW := w - (this.config["margin"]*8) - symbolH
        buttonText := this.GetButtonText()

        if (this.config["textUpper"]) {
            buttonText := StrUpper(buttonText)
        }

        textW := this.CalculateTextWidth(buttonText)

        if (textW > maxTextW) {
            textW := maxTextW
        }

        Gdip_TextToGraphics(this.graphics, buttonText, this.config["textAlign"] . " " . x . " W" . textW . " vCenter cff" . this.config["textColor"], this.config["font"], w, h)
        symbol := this.themeObj.GetSymbol("arrowDown", this.config)

        if (symbol) {
            symbolX := textW + (this.config["margin"]*2)
            symbolY := 0 + symbolMargin
            symbolW := symbolH
            symbol.Draw(this.graphics, symbolX, symbolY, symbolW, symbolH)
        }
    }

    CalculateTextWidth(text) {
        graphics := ""
        font := "Arial"
        size := 12
        options := "Regular"
        style := 0
        styles := "Regular|Bold|Italic|BoldItalic|Underline|Strikeout"
        formatStyle := 0x4000 | 0x1000

        for eachStyle, valStyle in StrSplit(styles, "|")
        {
            if RegExMatch(options, "\b" valStyle) {
                style |= (valStyle != "StrikeOut") ? (A_Index-1) : 8
            }  
        }

        hdc := GetDC()
        graphics := Gdip_GraphicsFromHDC(hdc)
        hFamily := Gdip_FontFamilyCreate(font)
        hFont := Gdip_FontCreate(hFamily, size, style)
        hFormat := Gdip_StringFormatCreate(formatStyle)
        CreateRectF(RC, 0, 0, 0, 0)
        returnRc := Gdip_MeasureString(graphics, text, hFont, hFormat, RC)
        returnRc := StrSplit(returnRc, "|")
        return returnRc[3]
    }
}
