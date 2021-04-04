class BasicControl extends GuiControlBase {
    CreateControl(value, ctlType, params*) {
        super.CreateControl()
        this.ctl := this.guiObj.guiObj.Add(ctlType, this.GetOptionsString(this.options), params*)

        if (value) {
            this.SetText(value)
        }

        return this.ctl
    }
}
