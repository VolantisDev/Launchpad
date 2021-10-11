class SingleInputBox extends DialogBox {
    GetDefaultConfig(container, config) {
        defaults := super.GetDefaultConfig(container, config)
        defaults["defaultValue"] := ""
        defaults["isPassword"] := false,
        defaults["buttons"] := "*&OK|&Cancel"
        return defaults
    }

    Controls() {
        super.Controls()
        this.guiObj.AddEdit("x" . this.margin . " w" . this.windowSettings["contentWidth"] . " -VScroll vDialogEdit" . (this.config["isPassword"] ? " Password" : "") . " c" . this.themeObj.GetColor("editText"), this.config["defaultValue"])
    }

    ProcessResult(result, submittedData := "") {
        value := this.guiObj["DialogEdit"].Value
        result := (result == "OK") ? value : ""
        return super.ProcessResult(result, submittedData)
    }
}
