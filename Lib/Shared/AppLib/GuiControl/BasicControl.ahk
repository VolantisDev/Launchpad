class BasicControl extends GuiControlBase {
    CreateControl(heading, ctlType, params*) {
        if (heading) {
            this.AddHeading(heading)
        }

        this.ctl := this.guiObj.Add(ctlType, this.GetOptionsString(this.options), params*)
        return this.ctl
    }
}
