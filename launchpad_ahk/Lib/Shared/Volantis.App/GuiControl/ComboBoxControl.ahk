class ComboBoxControl extends SelectControl {
    ctlType := "ComboBox"

    SetText(text, isIndex := false) {
        if (isIndex) {
            if (this.selectOptions.Has(text)) {
                this.ctl.Text := this.selectOptions[text]
            }
        } else {
            this.ctl.Text := text
        }
    }
}
