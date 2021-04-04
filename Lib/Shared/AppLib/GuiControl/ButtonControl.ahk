class ButtonControl extends GuiControlBase {
    CreateControl(handler := "", buttonStyle := "normal", drawConfig := "") {
        super.CreateControl(false)
        text := this.heading

        options := this.SetDefaultOptions(this.options.Clone(), ["h25", "w200", "xs", "y+" . this.guiObj.margin, "0xE"])
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
}
