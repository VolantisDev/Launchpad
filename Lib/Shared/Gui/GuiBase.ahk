class GuiBase {
    guiObj := ""
    title := ""
    themeObj := ""
    owner := ""
    parent := ""
    windowKey := ""
    isDialog := false
    windowSettings := Map()
    windowOptions := ""
    hasToolbar := false
    hToolbar := ""
    margin := ""

    positionAtMouseCursor := false
    openWindowWithinScreenBounds := true
    showInNotificationArea := false

    __New(title, themeObj, windowKey, owner := "", parent := "") {
        InvalidParameterException.CheckTypes("GuiBase", "title", title, "", "themeObj", themeObj, "ThemeBase", "windowKey", windowKey, "")
        InvalidParameterException.CheckEmpty("GuiBase", "title", title)

        if (owner != "") {
            if (owner.HasBase(GuiBase.Prototype)) {
                owner := owner.guiObj
            }

            InvalidParameterException.CheckTypes("GuiBase", "owner", owner, "Gui")
            this.owner := owner
        }

        if (parent != "") {
            if (parent.HasBase(GuiBase.Prototype)) {
                parent := parent.guiObj
            }

            InvalidParameterException.CheckTypes("GuiBase", "parent", parent, "Gui")
            this.parent := parent
        }

        this.title := title
        this.themeObj := themeObj
        this.windowSettings := themeObj.GetWindowSettings(windowKey)
        this.windowOptions := themeObj.GetWindowOptionsString(windowKey)
        this.margin := this.windowSettings["spacing"]["margin"]
        this.windowKey := windowKey
        this.Create()
    }

    /**
    * IMPLEMENTED METHODS
    */

    GetItemIndex(arr, itemValue) {
        result := ""

        for index, value in arr {
            if (value == itemValue) {
                result := index
                break
            }
        }

        return result
    }

    AddHeading(groupLabel, position := "") {
        if (position == "") {
            position := "x" . this.margin . " y+" . (this.margin * 2.5)
        }

        this.SetFont("normal", "Bold")
        this.guiObj.AddText(position . " w" . this.windowSettings["contentWidth"] . " Section +0x200", groupLabel)
        this.SetFont()
    }

    AddHelpText(helpText, position := "") {
        if (position == "") {
            position := "xs y+m"
        }

        this.guiObj.SetFont(this.themeObj.GetFont("small"))
        this.guiObj.AddText(position . " w" . this.windowSettings["contentWidth"] . " c" . this.themeObj.GetColor("textLight"), helpText)
        this.SetFont()
    }

    AddCheckBox(checkboxText, ctlName, checked, inGroupBox := true, callback := "", check3 := false) {
        if (callback == "") {
            callback := "On" . ctlName
        }

        width := this.windowSettings["contentWidth"]
        position := "xs"

        if (inGroupBox) {
            position .= "+" . this.margin
            width -= this.margin * 2
        }

        position .= " y+m"

        if (check3) {
            checked .= " Check3"
        }

        chk := this.guiObj.AddCheckBox(position . " w" . width . " v" . ctlName . " checked" . checked, checkboxText)
        chk.OnEvent("Click", callback)
    }

    SetFont(fontPreset := "normal", extraStyles := "", colorName := "text") {
        this.guiObj.SetFont()
        this.guiObj.SetFont("c" . this.themeObj.GetColor(colorName) . " " . this.themeObj.GetFont(fontPreset) . " " . extraStyles)
    }

    SetWindowKey(windowKey) {
        this.windowKey := windowKey
        this.windowSettings := this.themeObj.GetWindowSettings(windowKey)
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
        this.guiObj := Gui.New(this.windowOptions, this.GetTitle(this.title), this)
        this.guiObj.BackColor := this.themeObj.GetColor("background")
        this.guiObj.MarginX := this.margin
        this.guiObj.MarginY := this.margin

        this.SetFont()

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

    CreateToolbar(callback, imageList, btns) {
        ;return ToolbarCreate(callback, btns, imageList, "Flat List Tooltips")
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
        windowSize := ""

        width := this.windowSettings["contentWidth"] + (this.margin * 2)
        MonitorGetWorkArea(, monitorL, monitorT, monitorR, monitorB)

        if (this.positionAtMouseCursor) {    
            CoordMode("Mouse", "Screen")
            MouseGetPos(windowX, windowY)
            CoordMode("Mouse")
            windowX -= width/2
            windowSize .= " x" . windowX . " y" . windowY
        } else if (this.showInNotificationArea) {
            this.guiObj.GetPos(,,guiW, guiH)
            windowX := monitorR - this.margin - width
            windowY := monitorB - this.margin - guiH
            windowSize .= " x" . windowX . " y" . windowY
        }

        this.guiObj.Show(windowSize)

        ; @todo is this really needed?
        if (!this.positionAtMouseCursor and this.showInNotificationArea) {
            this.guiObj.GetPos(,,guiW, guiH)
            windowX := monitorR - this.margin - guiW
            windowY := monitorB - this.margin - guiH
            this.guiObj.Move(windowX, windowY)
        }

        transColorVal := this.themeObj.GetColor("transColor")
        if (transColorVal != "") {
            WinSetTransColor(transColorVal, "ahk_id " . this.guiObj.Hwnd)
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
    }

    Cleanup() {
        ; Extend to clear any global variables used
    }

    ButtonWidth(numberOfButtons, availableWidth := 0) {
        if (availableWidth == 0) {
            availableWidth := this.windowSettings["contentWidth"]
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
                info["redraw"] := InStr(options, "*")
                info["optionSplit"] := StrSplit(RegExReplace(options, "i)[^xywh]"))
                info := this.ParseDimensions(options, info)
                info := this.GetParentXY(ctl, options, info)
                this.guiObj.GetPos(,,guiWidth, guiHeight)
                info["gw"] := guiWidth
                info["gh"] := guiHeight
                controlInfo[ctl.Hwnd] := info
            } else {
                info := controlInfo[ctl.Hwnd]
                this.guiObj.GetPos(,,guiWidth, guiHeight)
                dgx := dgw := guiWidth - info["gw"]
                dgy := dgh := guiHeight - info["gh"]
                ctl.GetPos(newX, newY, newW, newH)

                for (i, dim in controlInfo[ctl.Hwnd]["optionSplit"]) {
                    new%dim% := dg%dim% * info["f" . dim] + info[dim]
                }

                ctl.Move(newX, newY, newW, newH)

                if controlInfo[ctl.Hwnd]["redraw"] {
                    ctl.Redraw()
                }
            }
        }
    }

    GetParentXY(ctl, options, infoMap) {
        if (InStr(options, "t")) {
            hParentWnd := DllCall("GetParent", "Ptr", ctl.Hwnd, "Ptr")

            VarSetStrCapacity(RECT, 16)
            DllCall("GetWindowRect", "Ptr", hParentWnd, "Ptr", StrPtr(RECT))
            DllCall("MapWindowPoints", "Ptr", 0, "Ptr", DllCall("GetParent", "Ptr", hParentWnd, "Ptr"), "Ptr", StrPtr(RECT), "UInt", 1)

            infoMap["x"] -= NumGet(RECT, 0, "Int")
            infoMap["y"] -= NumGet(RECT, 4, "Int")
        }

        return infoMap
    }

    ParseDimensions(options, infoMap) {
        optionSplit := StrSplit(RegExReplace(options, "i)[^xywh]"))
        fx := fy := fw := fh := 0

        for (, dim in optionSplit) {
            if (!RegExMatch(options, "i)" . dim . "\s*\K[\d.-]+", f%dim%)) {
                f%dim% := 1
            }
        }

        infoMap["fx"] := fx
        infoMap["fy"] := fy
        infoMap["fw"] := fw
        infoMap["fh"] := fh

        return infoMap
    }

    GetControlDimensions(ctlObj) {
        ctlObj.GetPos(ix, iy, iw, ih)
        return Map("x", ix, "y", iy, "w", iw, "h", ih)
    }

    Submit(hide := true) {
        this.guiObj.Submit(hide)
    }
}
