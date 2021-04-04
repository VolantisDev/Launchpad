class SelectControl extends GuiControlBase {
    selectOptions := []
    btnCtl := ""

    CreateControl(value, selectOptions, handler := "", helpText := "", buttonText := "", buttonHandler := "", buttonOpts := "") {
        super.CreateControl()
        this.selectOptions := selectOptions
        
        buttonW := buttonText ? this.CalculateTextWidth(buttonText) : 0

        fieldW := this.guiObj.windowSettings["contentWidth"]

        if (buttonW) {
            fieldW -= (buttonW + this.margin)
        }

        index := this.GetItemIndex(value)
        opts := this.SetDefaultOptions(this.options.Clone(), ["Choose" . index, "c" . this.guiObj.themeObj.GetColor("editText")])
        ctl := this.guiObj.guiObj.AddDDL(this.GetOptionsString(opts), this.selectOptions)
        this.ctl := ctl

        if (handler) {
            ctl.OnEvent("Change", handler)
        }

        if (helpText) {
            ctl.ToolTip := helpText
        }

        if (buttonText) {
            opts := this.SetDefaultOptions(buttonOpts, "x+m yp w" . buttonW . " h25")
            this.btnCtl := this.Add("ButtonControl", this.GetOptionsString(opts), buttonText, buttonHandler)
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
