class StatusIndicatorControl extends GuiControlBase {
    statusIndicatorW := 40
    statusIndicatorMinW := 40
    statusIndicatorExpandedMinW := 120
    innerControl := ""
    webService := ""

    CreateControl(webService, handler := "") {
        super.CreateControl(false)
        this.webService := webService

        if (handler == "" && HasMethod(this.guiObj, "OnStatusIndicatorClick")) {
            handler := "OnStatusIndicatorClick"
        }

        this.statusIndicatorW := webService["StatusIndicatorExpanded"] ? this.statusIndicatorExpandedMinW : this.statusIndicatorMinW

        options := this.parameters.SetDefaultOptions(this.parameters["options"].Clone(), [
            "x+" . this.guiObj.margin, 
            "yp", 
            "w" . this.statusIndicatorW, 
            "h26", 
            "vStatusIndicator" . webService.Id
        ])

        statusInfo := this.guiObj.GetStatusInfo(webService)
        statusStyle := this.guiObj.StatusWindowIsOnline(webService) ? "status" : "statusOffline"
        name := (statusInfo && statusInfo.Has("name") && webService["StatusIndicatorExpanded"]) ? statusInfo["name"] : ""
        photo := (statusInfo && statusInfo.Has("photo")) ? statusInfo["photo"] : ""

        this.innerControl := this.guiObj.Add("ButtonControl", options, name, handler, statusStyle, Map("photo", photo))
        this.ctl := this.innerControl.ctl
        return this.ctl
    }

    UpdateStatusIndicator() {
        statusInfo := this.guiObj.GetStatusInfo(this.webService)
        statusStyle := this.guiObj.StatusWindowIsOnline(this.webService) ? "status" : "statusOffline"

        oldW := this.statusIndicatorW
        newW := this.CalculateWidth(statusInfo)
        this.statusIndicatorW := newW
        difference := 0

        if (oldW != newW) {
            this.ctl.GetPos(&statusX,, &statusW)
            difference := newW - oldW
            this.ctl.Move(statusX - difference,, statusW + difference)
        }

        name := (statusInfo && statusInfo.Has("name") && this.webService["StatusIndicatorExpanded"]) ? statusInfo["name"] : ""
        photo := (statusInfo && statusInfo.Has("photo")) ? statusInfo["photo"] : ""

        this.guiObj.themeObj.DrawButton(this.ctl, name, statusStyle, Map("photo", photo))
        return difference
    }

    CalculateWidth(statusInfo) {
        expanded := this.webService["StatusIndicatorExpanded"]
        width := expanded ? this.statusIndicatorExpandedMinW : this.statusIndicatorMinW
        requiredW := 10

        if (statusInfo) {
            if (statusInfo.Has("name") && expanded) {
                requiredW += this.guiObj.themeObj.CalculateTextWidth(statusInfo["name"])
            }

            if (StatusInfo.Has("photo") || !expanded) {
                requiredW += 26
            }
        }

        if (requiredW > width) {
            width := requiredW
        }

        return Ceil(width)
    }
}
