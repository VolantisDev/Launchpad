class BasicControl extends GuiControlBase {
    CreateControl(ctlType, params*) {
        super.CreateControl()
        this.ctl := this.guiObj.Add(ctlType, this.GetOptionsString(this.options), params*)
        return this.ctl
    }
}
