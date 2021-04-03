class BasicControl extends GuiControlBase {
    CreateControl(heading, params*) {
        if (heading) {
            this.AddHeading(heading)
        }

        defaults := this.options.Clone()
        options := params.Has(2) ? params[2] : ""
        params[2] := this.SetDefaultOptions(options, defaults)
        this.ctl := this.guiObj.Add(params*)
        return this.ctl
    }
}
