class SelectControl extends GuiControlBase {
    selectOptions := []
    btnCtl := ""
    ctlType := "DDL"

    CreateControl(value, selectOptions, handler := "", helpText := "", buttonText := "", buttonHandler := "", buttonOpts := "") {
        super.CreateControl()
        this.selectOptions := selectOptions
        
        buttonW := buttonText ? (this.guiObj.themeObj.CalculateTextWidth(buttonText) + this.guiObj.margin*2) : 0

        opts := this.options.Clone()
        w := this.GetOption(opts, "w")

        if (w) {
            w := SubStr(w, 2)
        } else {
            w := this.guiObj.windowSettings["contentWidth"]
        }

        if (buttonW) {
            w -= (buttonW + this.guiObj.margin)
        }
        this.SetOption(opts, "w", w)

        fieldW := w
        
        defaults := ["w" . fieldW, "c" . this.guiObj.themeObj.GetColor("editText")]

        if (this.ctlType == "DDL") {
            index := this.GetItemIndex(value)
            defaults.Push("Choose" . index)
        }

        opts := this.SetDefaultOptions(opts, defaults)
        ctl := this.guiObj.guiObj.Add(this.ctlType, this.GetOptionsString(opts), this.selectOptions)

        if (!ctl) {
            throw AppException("Could not create select control")
        }

        if (this.ctlType == "ComboBox") {
            ctl.Text := value
        }

        this.ctl := ctl

        if (handler) {
            ctl.OnEvent("Change", handler)
        }

        if (helpText) {
            ctl.ToolTip := helpText
        }

        if (buttonText) {
            opts := this.SetDefaultOptions(buttonOpts, "x+m yp w" . buttonW . " h25")
            this.btnCtl := this.guiObj.Add("ButtonControl", this.GetOptionsString(opts), buttonText, buttonHandler)
        }

        return this.ctl
    }

    GetItemIndex(value) {
        index := 0

        for idx, val in this.selectOptions {
            if (value == val) {
                index := idx
                break
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
