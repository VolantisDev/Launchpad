class SingleInputBox extends DialogBox {
    defaultValue := ""
    isPassword := false

    __New(app, themeObj, windowKey, title, text, defaultValue := "", owner := "", parent := "", isPassword := false) {
        InvalidParameterException.CheckTypes("SingleInputBox", "defaultValue", defaultValue, "")
        this.defaultValue := defaultValue
        this.isPassword := isPassword
        super.__New(app, themeObj, windowKey, title, text, owner, parent, "*&OK|&Cancel")
    }

    Controls() {
        super.Controls()
        this.guiObj.AddEdit("x" . this.margin . " w" . this.windowSettings["contentWidth"] . " -VScroll vDialogEdit" . (this.isPassword ? " Password" : "") . " c" . this.themeObj.GetColor("editText"), this.defaultValue)
    }

    ProcessResult(result, submittedData := "") {
        value := this.guiObj["DialogEdit"].Value
        result := (result == "OK") ? value : ""
        return super.ProcessResult(result, submittedData)
    }
}
