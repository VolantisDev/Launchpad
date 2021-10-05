class ButtonControl extends GuiControlBase {
    CreateControl(handler := "", buttonStyle := "normal", drawConfig := "") {
        super.CreateControl(false)
        text := this.heading

        defaultOpts := ["h25", "xs", "y+" . this.guiObj.margin, "0xE"]
        defaultOpts.Push("w" . this.CalculateWidth(text, drawConfig))
        options := this.SetDefaultOptions(this.options.Clone(), defaultOpts)
        this.ctl := this.guiObj.guiObj.AddPicture(this.GetOptionsString(options))

        if (!handler && this.ctl.Name && HasMethod(this.guiObj, "On" . this.ctl.Name)) {
            handler := "On" . this.ctl.Name
        }

        if (handler) {
            this.ctl.OnEvent("Click", handler)
        }

        this.ctl := this.guiObj.themeObj.DrawButton(this.ctl, text, buttonStyle, drawConfig)
        return this.ctl
    }

    CalculateWidth(text, drawConfig := "") {
        return Ceil(this.guiObj.themeObj.CalculateTextWidth(text)) + (this.guiObj.margin*4)
    }
}
