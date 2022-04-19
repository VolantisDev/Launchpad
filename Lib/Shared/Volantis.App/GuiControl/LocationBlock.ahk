class LocationBlock extends GuiControlBase {
    btnCtl := ""

    CreateControl(location, fieldName, extraButton := "", showOpen := true, helpText := "", btnOptions := "", btnCallback := "") {
        super.CreateControl()

        textOptions := this.parameters["options"].Clone()
        w := this.parameters.GetOption("w")

        if (w) {
            w := SubStr(w, 2)
            w -= (20 + (this.guiObj.margin / 2))
            this.parameters.SetOption("w", w, textOptions)
        }
        
        ctl := this.AddText(location, this.parameters.SetDefaultOptions(textOptions, "v" . fieldName . " h22 c" . (this.guiObj.themeObj.GetColor("textLink")) . " y+" . (this.guiObj.margin/2) . " w" . (this.guiObj.windowSettings["contentWidth"]-20-(this.guiObj.margin/2))))
        this.ctl := ctl

        if (helpText) {
            ctl.ToolTip := helpText
        }

        menuItems := []
        menuItems.Push(Map("label", "Change", "name", "Change" . fieldName))

        if (showOpen) {
            menuItems.Push(Map("label", "Open", "name", "Open" . fieldName))
        }

        if (extraButton) {
            menuItems.Push(Map("label", extraButton, "name", StrReplace(extraButton, " ", "") . fieldName))
        }

        callback := this.RegisterCallback("OnLocationOptions")
        
        opts := this.parameters.GetOptionsString(btnOptions, [
            "v" . fieldName . "Options",
            "w20",
            "h20",
            "x+" . (this.guiObj.margin/2),
            "yp"
        ], false, false)

        btn := this.guiObj.Add("ButtonControl", opts, "arrowDown", callback, "symbol")

        btn.ctl.MenuItems := menuItems
        btn.ctl.ToolTip := "Change options"
        btn.ctl.Callback := btnCallback ? btnCallback : "On" . fieldName . "MenuClick"
        this.btnCtl := btn

        return ctl
    }

    OnLocationOptions(btn, info) {
        result := this.app.Service("manager.gui").Menu(Map(
            "parent", this.guiObj,
            "child", true
        ), btn.MenuItems, btn)

        if (result) {
            callback := btn.Callback

            if (HasMethod(callback)) {
                callback(result)
            } else {
                this.guiObj.%callback%(result)
            }
        }
    }

    ToggleEnabled(isEnabled) {
        super.ToggleEnabled(isEnabled)
        this.btnCtl.ctl.Visible := (isEnabled)
    }
}
