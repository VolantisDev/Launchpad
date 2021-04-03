class LocationBlock extends GuiControlBase {
    btnCtl := ""

    CreateControl(heading, fieldName, location, extraButton := "", showOpen := true, helpText := "", btnOptions := "") {
        if (heading) {
            this.AddHeading(heading)
        }

        textOptions := this.options.Clone()
        w := this.GetOption(textOptions, "w")

        if (w) {
            w := SubStr(w, 2)
            w -= (20 + (this.guiObj.margin / 2))
            this.SetOption(textOptions, "w", w)
        }
        
        textOptions := this.SetDefaultOptions(textOptions, "v" . fieldName . " h22 c" . (this.guiObj.themeObj.GetColor("linkText")) . " y+" . (this.guiObj.margin/2) . " w" . (this.guiObj.windowSettings["contentWidth"]-20-(this.guiObj.margin/2)))
        ctl := this.AddText(location, textOptions)
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
        btnOptions := this.SetDefaultOptions(btnOptions, "v" . fieldName . "Options w20 h20 x+" . (this.guiObj.margin/2) . " yp")
        btn := this.guiObj.Add("ButtonControl", this.GetOptionsString(btnOptions), "arrowDown", callback, "symbol")
        btn.MenuItems := menuItems
        btn.ToolTip := "Change options"
        btn.Callback := "On" . fieldName . "MenuClick"
        this.btnCtl := btn

        return ctl
    }

    OnLocationOptions(btn, info) {
        result := this.app.GuiManager.Menu("MenuGui", btn.MenuItems, this.guiObj, btn)

        if (result) {
            callback := btn.Callback
            this.guiObj.%callback%(result)
        }
    }

    ToggleEnabled(isEnabled) {
        super.ToggleEnabled(isEnabled)
        this.btnCtl.Visible := (isEnabled)
    }
}
