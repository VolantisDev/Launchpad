class SingleInputBox extends DialogBox {
    defaultValue := ""
    isPassword := false

    __New(app, title, text, defaultValue := "", owner := 0, isPassword := false) {
        this.defaultValue := defaultValue
        this.isPassword := isPassword
        
        base.__New(app, title, text, owner, "*&OK|&Cancel")
    }

    Controls(posY) {
        global DialogBox_Value

        posY := base.Controls(posY)
        Gui, DialogBox:Add, Edit, % "x" . this.margin . " y" . posY . " w" . this.contentWidth . " h20 -VScroll vDialogBox_Value" . (this.isPassword ? " Password" : ""), % this.defaultValue
        posY += 20 + this.margin

        return posY
    }

    ProcessResult(result) {
        global DialogBox_Value

        result := (result == "OK") ? DialogBox_Value : ""

        return base.ProcessResult(result)
    }
}
