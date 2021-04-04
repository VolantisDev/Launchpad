class SelectControl extends GuiControlBase {
    selectOptions := []

    CreateControl(value, selectOptions, handler := "", buttonText := "", buttonHandler := "", buttonOpts := "") {
        super.CreateControl()
        this.selectOptions := selectOptions
        
        buttonW := buttonText ? this.CalculateTextWidth(buttonText) : 0

        fieldW := this.guiObj.windowSettings["contentWidth"]

        if (buttonW) {
            fieldW -= (buttonW + this.margin)
        }

        index := this.GetItemIndex(value)
        opts := this.SetDefaultOptions(this.options.Clone(), ["Choose" . index, "c" . this.themeObj.GetColor("editText")])
        ctl := this.guiObj.guiObj.AddDDL(opts, this.selectOptions)
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
