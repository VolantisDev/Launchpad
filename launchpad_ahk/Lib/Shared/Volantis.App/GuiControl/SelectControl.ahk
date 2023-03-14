class SelectControl extends GuiControlBase {
    selectOptions := []
    btnCtl := ""
    ctlType := "DDL"

    CreateControl(value, selectOptions, handler := "", helpText := "", buttonText := "", buttonHandler := "", buttonOpts := "") {
        super.CreateControl()
        this.selectOptions := selectOptions
        
        buttonW := buttonText ? (this.guiObj.themeObj.CalculateTextWidth(buttonText) + this.guiObj.margin*2) : 0

        opts := this.parameters["options"].Clone()
        w := this.parameters.GetOption("w")

        if (w) {
            w := SubStr(w, 2)
        } else {
            w := this.guiObj.windowSettings["contentWidth"]
        }

        if (buttonW) {
            w -= (buttonW + this.guiObj.margin)
        }
        this.parameters.SetOption("w", w, opts)

        fieldW := w
        
        defaults := ["w" . fieldW, "c" . this.guiObj.themeObj.GetColor("editText")]

        if (this.ctlType == "DDL") {
            index := this.GetItemIndex(value)
            defaults.Push("Choose" . index)
        }

        selectOptions := this.selectOptions

        if (!selectOptions) {
            selectOptions := []
        }

        ctl := this.guiObj.guiObj.Add(this.ctlType, this.parameters.GetOptionsString(opts, defaults), selectOptions)

        if (!ctl) {
            throw AppException("Could not create select control")
        }

        if (this.ctlType == "ComboBox") {
            ctl.Text := value
        }

        if (handler) {
            ctl.OnEvent("Change", handler)
        }

        if (helpText) {
            ctl.ToolTip := helpText
        }

        this.ctl := ctl

        if (buttonText) {
            this.btnCtl := this.guiObj.Add("ButtonControl", this.parameters.GetOptionsString(buttonOpts, [
                "x+m", 
                "yp", 
                "w" . buttonW, "h25"
            ], false, false), buttonText, buttonHandler)
        }

        return this.ctl
    }

    GetItemIndex(value) {
        index := 0

        if (Type(this.selectOptions) == "Array") {
            for idx, val in this.selectOptions {
                if (value == val) {
                    index := idx
                    break
                }
            }
        }

        return index
    }

    SetText(text, isIndex := false) {
        index := 0

        if (isIndex) {
            index := text
        } else {
            index := this.GetItemIndex(text)
        }

        if (index) {
            this.ctl.Value := index
        }
    }
}
