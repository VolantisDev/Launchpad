class LocationBlock extends GuiControlBase {
    RegisterCallbacks() {
        this.callbacks["LocationOptions"] := ObjBindMethod(this, "OnLocationOptions")
    }

    CreateControl(heading, fieldName, location, extraButton := "", showOpen := true, helpText := "") {
        this.AddHeading(heading)

        ctl := this.AddText(location, "v" . fieldName . " h22 c" . this.guiObj.themeObj.GetColor("linkText") . " w" . (this.guiObj.windowSettings["contentWidth"]-20-(this.guiObj.margin/2)))

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
        btn := this.guiObj.AddButton("w20 h20 x+" . (this.guiObj.margin/2) . " yp", "arrowDown", callback, "symbol")
        btn.MenuItems := menuItems
        btn.ToolTip := "Change options"

        return ctl
    }

    OnLocationOptions(btn, info) {
        result := this.app.GuiManager.Menu("MenuGui", btn.MenuItems, this.guiObj, btn)

        if (result) {
            callback := "On" . result
            this.guiObj.%callback%(btn, info)
        }
    }
}
