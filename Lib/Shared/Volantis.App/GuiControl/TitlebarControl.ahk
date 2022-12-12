class TitlebarControl extends GuiControlBase {
    topMargin := 10
    showIcon := true
    iconCtl := ""
    iconW := 16
    titlebarH := 31
    titlebarButtonW := 16
    initialStatusIndicatorW := 120
    titleButton := ""
    titleText := ""
    statusIndicator := ""
    minBtn := ""
    maxBtn := ""
    unmaxBtn := ""
    closeBtn := ""
    spacer := ""

    CreateControl(titleMenu := false, iconSrc := "") {
        super.CreateControl(false)
        titleText := this.heading
        titlebarW := this.guiObj.windowSettings["contentWidth"] + (this.guiObj.margin * 2)
        startingPos := "x" . this.guiObj.margin . " y" . this.topMargin
        textPos := startingPos

        if (!iconSrc) {
            iconSrc := A_IconFile
        }

        if (this.showIcon && iconSrc) {
            this.iconCtl := this.guiObj.guiObj.AddPicture(startingPos . " h" . this.iconW . " w" . this.iconW . " +BackgroundTrans vTitlebarIcon", iconSrc)
            textPos := "x" . (this.iconW + (this.guiObj.margin * 1.5)) . " y" . this.topMargin
        }

        buttonsW := 0
        statusIndicatorW := this.guiObj.config["showStatusIndicator"] ? this.initialStatusIndicatorW : 0

        if (this.guiObj.config["showStatusIndicator"]) {
            buttonsW += statusIndicatorW + (this.guiObj.margin * 2)
        }

        if (this.guiObj.config["showMinimize"]) {
            buttonsW += this.titlebarButtonW + this.guiObj.margin
        }

        if (this.guiObj.config["showMaximize"]) {
            buttonsW += this.titlebarButtonW + this.guiObj.margin
        }

        if (this.guiObj.config["showClose"]) {
            buttonsW += this.titlebarButtonW + this.guiObj.margin
        }

        if (buttonsW) {
            buttonsW += (this.guiObj.margin * 2)
        }

        textW := titlebarW - buttonsW
        buttonsX := textW

        if (iconSrc) {
            offset := this.iconW + (this.guiObj.margin/2)
            textW -= offset
            buttonsX += offset
        }

        if (titleMenu) {
            titlebarButtonW := 200

            try {
                titleButtonW := this.guiObj.themeObj.CalculateTextWidth(titleText) + (this.guiObj.margin*2.5)
            } catch as ex {
                throw AppException("Could not determine title text width. There seems to be a problem with GDI+.")
            }

            if (titleButtonW > textW) {
                titleButtonW := textW
            }

            opts := textPos . " w" . titleButtonW . " h20 vWindowTitleText"
            handler := this.RegisterCallback("OnWindowTitleTextClick")
            this.titleButton := this.guiObj.Add("ButtonControl", opts, titleText, handler, "mainMenu")
        } else {
            opts := textPos . " w" . textW . " vWindowTitleText c" . this.guiObj.themeObj.GetColor("textInactive") . " +BackgroundTrans"
            this.titleText := this.guiObj.guiObj.AddText(opts, titleText)
        }

        if (this.guiObj.config["showStatusIndicator"]) {
            opts := "x" . buttonsX . " y" . (this.topMargin - 5) . " w" . statusIndicatorW
            statusStyle := this.guiObj.StatusWindowIsOnline() ? "status" : "statusOffline"
            initialInfo := Map()
            statusInfo := this.guiObj.GetStatusInfo()

            if (statusInfo) {
                initialInfo := statusInfo.Clone()
                initialInfo["name"] := ""
            }
            
            this.statusIndicator := this.guiObj.Add("StatusIndicatorControl", opts, "", initialInfo, "", statusStyle)
            difference := this.statusIndicator.UpdateStatusIndicator(statusInfo, statusStyle)
            buttonsX += this.initialStatusIndicatorW + (this.guiObj.margin * 2)
        }

        handler := this.RegisterCallback("OnTitlebarButtonClick")

        if (this.guiObj.config["showMinimize"]) {
            this.minBtn := this.AddTitlebarButton("WindowMinButton", "minimize", handler, false, buttonsX)
        }

        if (this.guiObj.config["showMaximize"]) {
            this.maxBtn := this.AddTitlebarButton("WindowMaxButton", "maximize", handler)
            this.unMaxBtn := this.AddTitlebarButton("WindowUnmaxButton", "unmaximize", handler, true)
            this.unMaxBtn.Visible := false
        }

        if (this.guiObj.config["showClose"]) {
            this.closeBtn := this.AddTitlebarButton("WindowCloseButton", "close", handler)
        }

        this.ctl := this.guiObj.guiObj.AddPicture("x0 y0 w" . titlebarW . " h" . this.titlebarH . " vWindowTitlebar +BackgroundTrans", "")
        this.ctl.OnEvent("Click", this.RegisterCallback("OnWindowTitleClick"))
        this.ctl.OnEvent("DoubleClick", this.RegisterCallback("OnTitlebarDoubleClick"))

        this.spacer := this.guiObj.guiObj.AddText("x" . this.guiObj.margin . " y" . this.titlebarH . " w0 h0", "")

        return this.ctl
    }

    OnWindowTitleTextClick(btn, info) {
        this.guiObj.ShowTitleMenu()
    }

    AddTitlebarButton(name, symbol, handlerName, overlayPrevious := false, xPos := "") {
        if (xPos == "") {
            xPos := "+" . this.guiObj.margin
        }

        if (overlayPrevious) {
            xPos := "p"
        }

        position := overlayPrevious ? "xp yp" : "x" . xPos . " y10"
        options := position . " w16 h16 v" . name
        return this.guiObj.Add("ButtonControl", options, symbol, handlerName, "titlebar")
    }

    OnTitlebarButtonClick(btn, info) {
        winId := "ahk_id " . this.guiObj.GetHwnd()
        minMaxResult := WinGetMinMax(winId)

        if (this.minBtn && btn == this.minBtn.ctl) {
            if (minMaxResult == -1) {
                this.guiObj.Restore()
            } else {
                this.guiObj.Minimize()
            }
        } else if ((this.maxBtn && btn == this.maxBtn.ctl) || (this.unmaxBtn && btn == this.unmaxBtn.ctl)) {
            if (minMaxResult == 1) {
                this.guiObj.Restore()
            } else {
                this.guiObj.Maximize()
            }
        } else if (btn == this.closeBtn.ctl) {
            this.guiObj.canceled := true
            this.guiObj.Close()
        }
    }

    OnWindowTitleClick(btn, info) {
        PostMessage(0xA1, 2,,, "A")
    }

    OnTitlebarDoubleClick(btn, info) {
        if (this.guiObj.config["showMaximize"]) {
            winId := "ahk_id " . this.guiObj.GetHwnd()
            minMaxResult := WinGetMinMax(winId)

            if (minMaxResult == 1) {
                this.guiObj.Restore()
            } else {
                this.guiObj.Maximize()
            }
        }
    }

    OnSize(guiObj, minMax, width, height) {
        if (minMax == 1 and this.guiObj.config["showMaximize"]) {
            this.guiObj.guiObj["WindowUnmaxButton"].Visible := true
            this.guiObj.guiObj["WindowMaxButton"].Visible := false
        } else if (minMax != 1 && this.guiObj.config["showMaximize"]) {
            this.guiObj.guiObj["WindowUnmaxButton"].Visible := false
            this.guiObj.guiObj["WindowMaxButton"].Visible := true
        }

        if (minMax == -1) {
            return
        }

        this.guiObj.AutoXYWH("w", ["WindowTitlebar"])

        if (this.guiObj.config["showStatusIndicator"]) {
            this.guiObj.AutoXYWH("x*", ["StatusIndicator"])
        }

        if (this.guiObj.config["showClose"]) {
            this.guiObj.AutoXYWH("x*", ["WindowCloseButton"])
        }

        if (this.guiObj.config["showMaximize"]) {
            this.guiObj.AutoXYWH("x*", ["WindowMaxButton", "WindowUnmaxButton"])
        }

        if (this.guiObj.config["showMinimize"]) {
            this.guiObj.AutoXYWH("x*", ["WindowMinButton"])
        }
    }
}
