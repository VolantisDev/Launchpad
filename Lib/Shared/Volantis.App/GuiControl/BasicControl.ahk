class BasicControl extends GuiControlBase {
    CreateControl(value, ctlType, params*) {
        super.CreateControl()
        defaults := []

        if (ctlType == "Edit" || ctlType == "DDL" || ctlType == "ComboBox") {
            defaults.Push("c" . this.guiObj.themeObj.GetColor("editText"))
        }

        this.ctl := this.guiObj.guiObj.Add(ctlType, this.parameters.GetOptionsString(this.parameters["options"], defaults), params*)

        if (value) {
            this.SetText(value)
        }

        return this.ctl
    }
}
