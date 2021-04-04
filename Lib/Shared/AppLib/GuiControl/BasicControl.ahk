class BasicControl extends GuiControlBase {
    CreateControl(value, ctlType, params*) {
        super.CreateControl()
        defaults := []

        if (ctlType == "Edit" || ctlType == "DDL" || ctlType == "ComboBox") {
            defaults.Push("c" . this.guiObj.themeObj.GetColor("editText"))
        }

        opts := this.SetDefaultOptions(this.options, defaults)
        this.ctl := this.guiObj.guiObj.Add(ctlType, this.GetOptionsString(this.options), params*)

        if (value) {
            this.SetText(value)
        }

        return this.ctl
    }
}
