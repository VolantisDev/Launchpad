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

    CreateControl(titleText, titleMenu := false, iconSrc := "") {
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
        statusIndicatorW := this.guiObj.showStatusIndicator ? this.initialStatusIndicatorW : 0

        if (this.guiObj.showStatusIndicator) {
            buttonsW += statusIndicatorW + (this.guiObj.margin * 2)
        }

        if (this.guiObj.showMinimize) {
            buttonsW += this.titlebarButtonW + this.guiObj.margin
        }

        if (this.guiObj.showMaximize) {
            buttonsW += this.titlebarButtonW + this.guiObj.margin
        }

        if (this.guiObj.showCLose) {
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
            titleButtonW := this.guiObj.themeObj.CalculateTextWidth(titleText) + 25
            ; TODO: Determine how to calculate this "25" number

            if (titleButtonW > textW) {
                titleButtonW := textW
            }

            opts := textPos . " w" . titleButtonW . " h20 vWindowTitleText"
            handler := this.RegisterCallback("OnWindowTitleTextClick")
            this.titleButton := this.guiObj.Add("ButtonControl", opts, titleText, handler, "mainMenu")
        } else {
            opts := textPos . " w" . textW . " vWindowTitleText c" . this.guiObj.themeObj.GetColor("textLight") . " +BackgroundTrans"
            this.titleText := this.guiObj.guiObj.AddText(opts, titleText)
        }

        if (this.guiObj.showStatusIndicator) {
            opts := "x" . buttonsX . " y" . (this.topMargin - 5) . " w" . statusIndicatorW
            statusStyle := this.guiObj.StatusWindowIsOnline() ? "status" : "statusOffline"
            statusInfo := this.guiObj.GetStatusInfo()
            this.statusIndicator := this.guiObj.Add("StatusIndicatorControl", opts, statusInfo, "", statusStyle)
            buttonsX += this.statusIndicator.UpdateStatusIndicator(statusInfo, statusStyle) + (this.guiObj.margin * 2)
        }

        handler := this.RegisterCallback("OnTitlebarButtonClick")

        if (this.guiObj.showMinimize) {
            this.minBtn := this.AddTitlebarButton("WindowMinButton", "minimize", handler, false, buttonsX)
        }

        if (this.guiObj.showMaximize) {
            this.maxBtn := this.AddTitlebarButton("WindowMaxButton", "maximize", handler)
            this.unMaxBtn := this.AddTitlebarButton("WindowUnmaxButton", "unmaximize", handler, true)
            this.unMaxBtn.Visible := false
        }

        if (this.guiObj.showClose) {
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
            this.guiObj.Close()
        }
    }

    OnWindowTitleClick(btn, info) {
        PostMessage(0xA1, 2,,, "A")
    }

    OnTitlebarDoubleClick(btn, info) {
        if (this.guiObj.showMaximize) {
            winId := "ahk_id " . this.guiObj.GetHwnd()
            minMaxResult := WinGetMinMax(winId)

            if (minMaxResult == 1) {
                this.guiObj.Restore()
            } else {
                this.guiObj.Maximize()
            }
        }
    }

    OnSize(minMax, width, height) {
        if (minMax == 1 and this.guiObj.showMaximize) {
            this.guiObj.guiObj["WindowUnmaxButton"].Visible := true
            this.guiObj.guiObj["WindowMaxButton"].Visible := false
        } else if (minMax != 1 && this.guiObj.showMaximize) {
            this.guiObj.guiObj["WindowUnmaxButton"].Visible := false
            this.guiObj.guiObj["WindowMaxButton"].Visible := true
        }

        if (minMax == -1) {
            return
        }

        this.guiObj.AutoXYWH("w", ["WindowTitlebar"])

        if (this.guiObj.showStatusIndicator) {
            this.guiObj.AutoXYWH("x*", ["StatusIndicator"])
        }

        if (this.guiObj.showClose) {
            this.guiObj.AutoXYWH("x*", ["WindowCloseButton"])
        }

        if (this.guiObj.showMaximize) {
            this.guiObj.AutoXYWH("x*", ["WindowMaxButton", "WindowUnmaxButton"])
        }

        if (this.guiObj.showMinimize) {
            this.guiObj.AutoXYWH("x*", ["WindowMinButton"])
        }
    }
}
