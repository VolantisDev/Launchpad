class StatusIndicatorControl extends GuiControlBase {
    statusIndicatorW := 120
    statusIndicatorMinW := 120
    innerControl := ""

    CreateControl(statusInfo, handler := "", statusStyle := "status") {
        super.CreateControl(false)

        if (handler == "" && HasMethod(this.guiObj, "OnStatusIndicatorClick")) {
            handler := "OnStatusIndicatorClick"
        }

        options := this.parameters.SetDefaultOptions(this.parameters["options"].Clone(), [
            "x+" . this.guiObj.margin, 
            "yp", 
            "w" . this.statusIndicatorW, 
            "h26", 
            "vStatusIndicator"
        ])
        
        name := statusInfo && statusInfo.Has("name") ? statusInfo["name"] : ""
        photo := statusInfo && statusInfo.Has("photo") ? statusInfo["photo"] : ""

        this.innerControl := this.guiObj.Add("ButtonControl", options, name, handler, statusStyle, Map("photo", photo))
        this.ctl := this.innerControl.ctl
        return this.ctl
    }

    UpdateStatusIndicator(statusInfo, statusStyle := "status") {
        oldW := this.statusIndicatorW
        newW := this.CalculateWidth(statusInfo)
        this.statusIndicatorW := newW
        difference := 0

        if (oldW != newW) {
            this.ctl.GetPos(&statusX,, &statusW)
            difference := newW - oldW
            this.ctl.Move(statusX - difference,, statusW + difference)
        }

        name := statusInfo && statusInfo.Has("name") ? statusInfo["name"] : ""
        photo := statusInfo && statusInfo.Has("photo") ? statusInfo["photo"] : ""

        this.guiObj.themeObj.DrawButton(this.ctl, name, statusStyle, Map("photo", photo))
        return difference
    }

    CalculateWidth(statusInfo) {
        width := this.statusIndicatorMinW
        requiredW := 10

        if (statusInfo) {
            if (statusInfo.Has("name")) {
                requiredW += this.guiObj.themeObj.CalculateTextWidth(statusInfo["name"])
            }

            if (StatusInfo.Has("photo")) {
                requiredW += 26
            }
        }

        if (requiredW > width) {
            width := requiredW
        }

        return Ceil(width)
    }
}
