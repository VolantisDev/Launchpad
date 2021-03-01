class SymbolButtonShape extends ButtonShape {
    RenderContent(w, h) {
        Gdip_TextToGraphics(this.graphics, this.GetButtonText(), "Center vCenter cff" . this.textColor, this.font, w, h)
    }

    GetButtonText() {
        btnText := this.btnText

        return StrReplace(btnText, "&", "")
    }
}
