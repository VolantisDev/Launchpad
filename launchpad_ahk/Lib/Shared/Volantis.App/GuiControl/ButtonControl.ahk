class ButtonControl extends GuiControlBase {
    CreateControl(handler := "", buttonStyle := "normal", drawConfig := "") {
        super.CreateControl(false)

        opts := this.parameters.GetOptionsString(this.parameters["options"], [
            "h25", 
            "xs", 
            "y+" . this.guiObj.margin, 
            "0xE",
            "w" . this.CalculateWidth(this.heading, drawConfig)
        ])

        this.ctl := this.guiObj.guiObj.AddPicture(opts)

        if (!handler && this.ctl.Name && HasMethod(this.guiObj, "On" . this.ctl.Name)) {
            handler := "On" . this.ctl.Name
        }

        if (handler) {
            this.ctl.OnEvent("Click", handler)
        }

        this.ctl := this.guiObj.themeObj.DrawButton(this.ctl, this.heading, buttonStyle, drawConfig)
        return this.ctl
    }

    CalculateWidth(text, drawConfig := "") {
        return Ceil(this.guiObj.themeObj.CalculateTextWidth(text)) + (this.guiObj.margin*4)
    }
}
