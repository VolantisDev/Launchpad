class SingleInputBox extends DialogBox {
    defaultValue := ""
    isPassword := false

    __New(app, title, text, defaultValue := "", owner := "", isPassword := false) {
        this.defaultValue := defaultValue
        this.isPassword := isPassword
        super.__New(app, title, text, owner, "*&OK|&Cancel")
    }

    Controls(posY) {
        posY := super.Controls(posY)
        this.guiObj.AddEdit("x" . this.margin . " y" . posY . " w" . this.contentWidth . " h20 -VScroll vDialogEdit" . (this.isPassword ? " Password" : ""), this.defaultValue)
        posY += 20 + this.margin
        return posY
    }

    ProcessResult(result) {
        value := this.guiObj["DialogEdit"].Value
        result := (result == "OK") ? value : ""
        return super.ProcessResult(result)
    }
}
