class CheckboxControl extends GuiControlBase {
    CreateControl(checked, text, helpText := "") {
        super.CreateControl()

        defaults := []

        if (checked) {
            defaults.Push(checked ? "Checked1" : "Checked0")
        }

        this.ctl := this.guiObj.guiObj.Add("CheckBox", this.parameters.GetOptionsString(this.parameters["options"], defaults), text)

        if (helpText) {
            this.ctl.ToolTip := helpText
        }

        return this.ctl
    }

    GetValue(submit := false) {
        if (submit) {
            this.guiObj.guiObj.Submit(false)
        }
        
        return !!(this.ctl.Value)
    }

    SetText(text) {
        this.ctl.Value := !!(text)
    }
}
