class GuiBase {
    app := ""
    guiObj := ""
    title := ""
    owner := ""
    windowOptions := ""
    windowSize := ""
    margin := 10
    contentWidth := 320
    hasToolbar := false
    hToolbar := ""
    positionAtMouseCursor := false
    windowKey := ""
    transColor := ""
    backgroundColor := "FFFFFF"
    textColor := "000000"
    accentColor := "9466FC"
    accentLightColor := "EEE6FF"
    accentDarkColor := "8A57F0"
    openWindowWithinScreenBounds := true

    __New(app, title, owner := "", windowKey := "") {
        this.app := app
        this.title := title
        this.windowKey := windowKey

        if (owner != "") {
            this.owner := (Type(owner) == "String") ? this.app.GuiManager.GetGuiObj(owner) : owner
        }

        this.Create()
    }

    SetWindowKey(windowKey) {
        this.windowKey := windowKey
    }

    GetHwnd() {
        return this.guiObj.Hwnd
    }

    GetTitle(title) {
        return title . " - Launchpad"
    }

    Show() {
        global hToolbar

        if (this.hasToolbar) {
            this.hToolbar := this.AddToolbar()
            hToolbar := this.hToolbar
        }

        this.Start()
        this.Controls()
        this.AddButtons()
        return this.End()
    }

    Create() {
        options := this.windowOptions
        margin := this.margin

        this.guiObj := Gui.New(this.windowOptions, this.GetTitle(this.title), this)
        this.guiObj.BackColor := this.backgroundColor
        this.guiObj.Color := this.textColor
        this.guiObj.MarginX := this.margin
        this.guiObj.MarginY := this.margin

        this.guiObj.OnEvent("Close", "OnClose")
        this.guiObj.OnEvent("Escape", "OnEscape")
        this.guiObj.OnEvent("Size", "OnSize")
    }

    OnClose(guiObj) {
        this.Destroy()
    }

    OnEscape(guiObj) {
        this.guiObj.Cancel()
        this.WinClose()
    }

    OnSize(guiObj, minMax, width, height) {

    }

    AddToolbar() {
        ; Define a callback and call CreateToolbar from this function if needed
        return false
    }

    CreateToolbar(callback, imageList, buttons) {
        ;return ToolbarCreate(callback, buttons, imageList, "Flat List Tooltips")
    }

    Start() {
        if (this.owner != "") {
            this.owner.Opt("Disabled")
            this.guiObj.Opt("+Owner" . this.owner.Hwnd)
	    }
    }

    Controls() {
    }

    AddButtons() {

    }

    End() {
        windowSize := this.windowSize

        if (this.positionAtMouseCursor) {
            width := this.contentWidth + (this.margin * 2)
            CoordMode("Mouse", "Screen")
            MouseGetPos(windowX, windowY)
            CoordMode("Mouse")
            windowX -= width/2
            windowSize .= " x" . windowX . " y" . windowY
        }

        this.guiObj.Show(windowSize)

        if (this.transColor != "") {
            WinSetTransColor(this.transColor, "ahk_id " . this.guiObj.Hwnd)
        }

        this.AdjustWindowPosition()

        return this
    }

    AdjustWindowPosition() {
        this.guiObj.GetPos(guiX, guiY, guiW, guiH)

        if (this.openWindowWithinScreenBounds) {
            ; Check which monitor the user completed the last action on and use that
            monitorId := MonitorGetPrimary()
            MonitorGetWorkArea(monitorId, screenL, screenT, screenR, screenB)

            moveGui := false

            if (guiX < screenL) {
                guiX := screenL
                moveGui := true
            } else if ((guiX + guiW) > screenR) {
                guiX := screenR - guiW
                moveGui := true
            }

            if (guiY < screenT) {
                guiY := screenT
                moveGui := true
            } else if ((guiY + guiH) > screenB) {
                guiY := screenB - guiH
                moveGui := true
            }

            screenW := screenR - screenL
            screenH := screenB - screenT

            if (guiW > screenW) {
                guiW := screenW
                moveGui := true
            }

            if (guiH > screenH) {
                guiH := screenH
                moveGUi := true
            }

            if (moveGui) {
                this.guiObj.Move(guiX, guiY, guiW, guiH)
            }
        }
    }

    Close(submit := false) {
        if (submit) {
            this.guiObj.Submit(true)
        } else {
            this.guiObj.Hide()
        }

        if (WinExist("ahk_id " . this.guiObj.Hwnd)) {
            WinClose("ahk_id " . this.guiObj.Hwnd)
        } else {
            this.Destroy()
        }
    }

    Destroy() {
        if (this.owner != "") {
            this.owner.Opt("-Disabled")
        }

        this.Cleanup()
        this.guiObj.Destroy()

        if (this.windowKey != "") {
            this.app.GuiManager.RemoveWindow(this.windowKey)
        }
    }

    Cleanup() {
        ; Extend to clear any global variables used
    }

    ButtonWidth(numberOfButtons, availableWidth := 0) {
        if (availableWidth == 0) {
            availableWidth := this.contentWidth
        }

        marginWidth := (numberOfButtons <= 1) ? 0 : (this.margin * (numberOfButtons - 1))
        return (availableWidth - marginWidth) / numberOfButtons
    }

    ; Originally based on https://www.autohotkey.com/boards/viewtopic.php?t=1079
    AutoXYWH(options, controls) {   
        static controlInfo := Map()

        if (options == "reset") {
            controlInfo := Map()
            return 
        }

        for (, ctl in controls) {
            if (!IsObject(ctl)) {
                ctl := this.guiObj[ctl]
            }

            if (!controlInfo.Has(ctl.Hwnd)) {
                info := this.GetControlDimensions(ctl)
                info.redraw := InStr(options, "*")
                info.optionSplit := StrSplit(RegExReplace(options, "i)[^xywh]"))
                info := this.ParseDimensions(options, info)
                info := this.GetParentXY(ctl, options, info)
                this.guiObj.GetPos(,,guiWidth, guiHeight)
                info.gw := guiWidth
                info.gh := guiHeight
                controlInfo[ctl.Hwnd] := info
            } else {
                info := controlInfo[ctl.Hwnd]
                this.guiObj.GetPos(,,guiWidth, guiHeight)
                dgx := dgw := guiWidth - info.gw
                dgy := dgh := guiHeight - info.gh
                ctl.GetPos(newX, newY, newW, newH)

                for (i, dim in controlInfo[ctlID]["optionSplit"]) {
                    new%dim% := dg%dim% * info["f" . dim] + info[dim]
                }

                ctl.Move(newX, newY, newW, newH)

                if controlInfo[ctl.Hwnd]["redraw"] {
                    ctl.Redraw()
                }
            }
        }
    }

    GetParentXY(ctl, options, infoObject) {
        if (InStr(options, "t")) {
            hParentWnd := DllCall("GetParent", "Ptr", ctl.Hwnd, "Ptr")

            VarSetStrCapacity(RECT, 16)
            DllCall("GetWindowRect", "Ptr", hParentWnd, "Ptr", StrPtr(RECT))
            DllCall("MapWindowPoints", "Ptr", 0, "Ptr", DllCall("GetParent", "Ptr", hParentWnd, "Ptr"), "Ptr", StrPtr(RECT), "UInt", 1)

            infoObject.x -= NumGet(RECT, 0, "Int")
            infoObject.y -= NumGet(RECT, 4, "Int")
        }

        return infoObject
    }

    ParseDimensions(options, infoObject) {
        optionSplit := StrSplit(RegExReplace(options, "i)[^xywh]"))
        fx := fy := fw := fh := 0

        for (, dim in optionSplit) {
            if (!RegExMatch(options, "i)" . dim . "\s*\K[\d.-]+", f%dim%)) {
                f%dim% := 1
            }
        }

        infoObject.fx := fx
        infoObject.fy := fy
        infoObject.fw := fw
        infoObject.fh := fh

        return infoObject
    }

    GetControlDimensions(ctlObj) {
        ctlObj.GetPos(ix, iy, iw, ih)
        return {x: ix, y: iy, w: iw, h: ih}
    }

    Submit(hide := true) {
        this.guiObj.Submit(hide)
    }
}
