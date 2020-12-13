; @todo WIP, need to finish
class IconSelector extends DialogBox {
    defaultValue := ""
    isPassword := false

    __New(title, themeObj, text, defaultValue := "", windowKey := "", owner := "", parent := "", isPassword := false) {
        InvalidParameterException.CheckTypes("SingleInputBox", "defaultValue", defaultValue, "")
        this.defaultValue := defaultValue
        this.isPassword := isPassword
        super.__New(title, themeObj, text, windowKey, owner, parent, "*&OK|&Cancel")
    }

    Controls() {
        super.Controls()
    }

    ProcessResult(result) {
        value := "" ; Get the selected icon path
        result := (result == "OK") ? value : ""
        return super.ProcessResult(result)
    }
}
