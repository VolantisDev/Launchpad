class SingleInputBox extends DialogBox {
    defaultValue := ""
    isPassword := false

    __New(title, text, defaultValue := "", owner := "", isPassword := false) {
        this.defaultValue := defaultValue
        this.isPassword := isPassword
        super.__New(title, text, owner, "*&OK|&Cancel")
    }

    Controls() {
        super.Controls()
        this.guiObj.AddEdit("x" . this.windowMargin . " w" . this.contentWidth . " -VScroll vDialogEdit" . (this.isPassword ? " Password" : ""), this.defaultValue)
    }

    ProcessResult(result) {
        value := this.guiObj["DialogEdit"].Value
        result := (result == "OK") ? value : ""
        return super.ProcessResult(result)
    }
}
