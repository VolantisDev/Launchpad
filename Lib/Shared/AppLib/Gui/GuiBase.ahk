class GuiBase {
    app := ""
    guiObj := ""
    guiId := ""
    title := ""
    iconSrc := ""
    themeObj := ""
    owner := ""
    parent := ""
    windowKey := ""
    windowSettingsKey := ""
    windowSettings := Map()
    windowOptions := ""
    margin := ""
    buttons := []
    isClosed := false
    activeTooltip := false
    showTitlebar := true
    showIcon := true
    showTitle := true
    showClose := true
    showMinimize := true
    showMaximize := false
    lv := ""
    lvHeaderHwnd := 0
    listViewColumns := []
    eventManagerObj := ""
    mouseMoveCallback := ""
    calcSizeCallback := ""
    activateCallback := ""
    hitTestCallback := ""
    headerCustomDrawCallback := ""
    tabsCustomDrawCallback := ""
    tabsHwnd := ""
    tabNames := []
    frameShadow := true
    showStatusIndicator := false
    showOptions := ""
    titleIsMenu := false
    openAtCtl := ""
    openAtCtlSide := "bottom" ; bottom or right
    waitForResult := false
    result := ""
    canceled := false
    statusIndicator := ""
    titlebar := ""
    positionAtMouseCursor := false
    openWindowWithinScreenBounds := true
    showInNotificationArea := false
    width := ""

    __New(app, themeObj, windowKey, title, owner := "", parent := "", iconSrc := "") {
        InvalidParameterException.CheckTypes("GuiBase", "app", app, "AppBase", "title", title, "", "themeObj", themeObj, "ThemeBase", "windowKey", windowKey, "")
        InvalidParameterException.CheckEmpty("GuiBase", "title", title)

        this.app := app

        if (owner) {
            owner := this.app.GuiManager.DereferenceGui(owner)
            
            if (owner) {
                this.owner := owner
            }
        }

        if (parent) {
            parent := this.app.GuiManager.DereferenceGui(parent)
            
            if (parent) {
                this.parent := parent
            }
        }

        extraOptions := Map()

        if (this.showTitlebar) {
            extraOptions["Caption"] := false
            extraOptions["Border"] := true
        }

        if (this.owner != "" && this.app.GuiManager.GetWindowFromGui(this.owner)) {
            extraOptions["Owner" . this.owner.Hwnd] := true
        }

        if (this.windowSettingsKey == "") {
            this.windowSettingsKey := Type(this)
        }
        
        this.title := title
        this.iconSrc := iconSrc
        this.themeObj := themeObj
        this.windowSettings := themeObj.GetWindowSettings(this.windowSettingsKey)
        this.windowOptions := themeObj.GetWindowOptionsString(this.windowSettingsKey, extraOptions)

        options := this.windowSettings["options"]

        if (options.Has("Resize") && options["Resize"]) {
            this.showMaximize := true
        }

        if (this.owner || options.Has("Popup") && options["Popup"]) {
            this.showMinimize := false
        }

        this.margin := this.windowSettings["spacing"]["margin"]
        this.windowKey := windowKey
        this.guiId := this.app.IdGen.Generate()

        this.RegisterCallbacks()
        this.Create()
    }

    RegisterCallbacks() {
        this.mouseMoveCallback := ObjBindMethod(this, "OnMouseMove")
        this.app.Events.Register(Events.MOUSE_MOVE, "Gui" . this.guiId, this.mouseMoveCallback)
        this.calcSizeCallback := ObjBindMethod(this, "OnCalcSize")
        this.app.Events.Register(Events.WM_NCCALCSIZE, "Gui" . this.guiId, this.calcSizeCallback)
        this.activateCallback := ObjBindMethod(this, "OnActivate")
        this.app.Events.Register(Events.WM_NCACTIVATE, "Gui" . this.guiId, this.activateCallback)
        this.hitTestCallback := ObjBindMethod(this, "OnHitTest")
        this.app.Events.Register(Events.WM_NCHITTEST, "Gui" . this.guiId, this.hitTestCallback)
        this.tabsCustomDrawCallback := ObjBindMethod(this, "OnTabsDraw")
        this.tabsSubclassCallback := ObjBindMethod(this, "OnTabsSubclass")
        this.tabsAdjustRectCallback := ObjBindMethod(this, "OnTabsAdjustRect")
    }

    OnCheckbox(chk, info) {
        ; TODO: Remove the need for a dummy callback
    }

    __Delete() {
        if (this.app) {
            this.app.Events.Unregister(Events.MOUSE_MOVE, "Gui" . this.guiId, this.mouseMoveCallback)
            this.app.Events.Unregister(Events.WM_NCCALCSIZE, "Gui" . this.guiId, this.calcSizeCallback)
            this.app.Events.Unregister(Events.WM_NCACTIVATE, "Gui" . this.guiId, this.activateCallback)
            this.app.Events.Unregister(Events.WM_NCHITTEST, "Gui" . this.guiId, this.hitTestCallback)
        }
        
        if (this.activeTooltip) {
            ToolTip()
            this.activeTooltip := false
        }

        super.__Delete()
    }

    OnMouseMove(wParam, lParam, msg, hwnd) {
        if (this.activeTooltip == hwnd) {
            return
        }

        guiCtl := GuiCtrlFromHwnd(hwnd)

        if (guiCtl && guiCtl.HasProp("ToolTip")) {
            this.activeTooltip := hwnd
            tooltipText := guiCtl.ToolTip
            SetTimer () => this.ShowTooltip(tooltipText, hwnd), -1000
        } else {
            ToolTip()
            this.activeTooltip := false
        }
    }

    Add(ctlClass, options := "", params*) {
        return %ctlClass%.new(this, options, params*)
    }

    OnCalcSize(wParam, lParam, msg, hwnd) {
        if hwnd == A_ScriptHwnd || hwnd == this.GetHwnd() {
            if (wParam) {
                ; TODO: Figure out how to use this callback to redefine the client window size to exclude the border
                return 0 ; Size the client area to fill the entire window
            }
        }
    }

    OnActivate(wParam, lParam, msg, hwnd) {
        if hwnd == A_ScriptHwnd || hwnd == this.GetHwnd() {
            return 1 ; Prevents a border from being drawn when the window is activated
        }
            
    }

    OnHitTest(wParam, lParam, msg, hwnd) {
        ; TODO: Replace titlebar callbacks with https://autohotkey.com/board/topic/23969-resizable-window-border/#entry155480

        static border_size := 6

        if hwnd != A_ScriptHwnd && hwnd != this.GetHwnd()
            return
        
        WinGetPos(gX, gY, gW, gH, "ahk_id " . this.guiObj.Hwnd)

        x := lParam<<48>>48
        y := lParam<<32>>48
        hitLeft := x < gX + border_size
        hitRight := x >= gX + gW - border_size
        hitTop := y < gY + border_size
        hitBottom := y >= gY + gH - border_size

        if (hitTop) {
            if (hitLeft) {
                return 0xD
            } else if (hitRight) {
                return 0xE
            } else {
                return 0xC
            }
        } else if (hitBottom) {
            if (hitLeft) {
                return 0x10
            } else if (hitRight) {
                return 0x11
            } else {
                return 0xF
            }
        } else if (hitLeft) {
            return 0xA
        } else if (hitRight) {
            return 0xB
        }
    }

    ShowTooltip(text, hwnd) {
        ctlHwnd := ""
        
        if (hwnd) {
            MouseGetPos(,,,ctlHwnd, 2)
        }

        if (!hwnd or ctlHwnd == hwnd) {
            this.activeTooltip := hwnd
            ToolTip(text)
        } else {
            this.activeTooltip := false
        }
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
            position := "x" . this.margin . " y+" . (this.margin * 2)
        }

        this.SetFont("normal", "Bold")
        this.guiObj.AddText(position . " w" . this.windowSettings["contentWidth"] . " Section +0x200", groupLabel)
        this.SetFont()
    }

    AddTabs(name, tabNames, options) {
        static TCS_OWNERDRAWFIXED := 0x2000
        styling := " +0x100 +" . TCS_OWNERDRAWFIXED
        tabs := this.guiObj.Add("Tab3", "v" . name . " w" . this.windowSettings["contentWidth"] . styling . " " . options, tabNames)
        this.tabsHwnd := tabs.Hwnd
        this.tabNames := tabNames
        this.SubclassControl(tabs.Hwnd, this.tabsSubclassCallback)
        return tabs
    }

    OnTabsAdjustRec(wParam, lParam, msg, hwnd) {
        
    }

    OnTabsSubclass(h, m, w, l, idSubclass, refData) {
        static TCM_ADJUSTRECT := 0x1328
        static WM_DESTROY := 0x02
        static WM_PAINT := 0xF

        Critical

        static OMsg := A_PtrSize

        if (this.tabsHwnd == h && m == WM_PAINT) {
            ; TODO: Paint tab headers
        } else if (m == WM_DESTROY) {
            this.SubclassControl(h, "")
        }

        ; All messages not completely handled by the function must be passed to the DefSubclassProc:
        return DllCall("DefSubclassProc", "Ptr", h, "UInt", m, "Ptr", w, "Ptr", l, "Ptr")
    }

    OnTabsDraw(wParam, lParam, msg, hwnd) {
        static ODS_SELECTED := 0x0001
        static ODS_FOCUS := 0x0010

        static DT_LEFT := 0
        static DT_END_ELLIPSIS := 0x00008000
        static DT_VCENTER := 0x00000004

        static ODA_DRAWENTIRE := 1
        static ODA_FOCUS := 4
        static ODA_SELECT := 2

        static ODT_TAB := 101

        static OCtlType := 0
        static OCtlId := A_PtrSize
        static OItemId := A_PtrSize*2
        static OItemAction := A_PtrSize*3
        static OHDC := A_PtrSize*4
        static ORect := A_PtrSize*5

        ctlType := NumGet(lParam + 0, OCtlType, "UInt")

        if (ctlType == ODT_TAB && hwnd == this.guiObj.Hwnd) {
            tabIndex := NumGet(lParam + 0, OCtlId, "UInt")
            isSelected := NumGet(lParam + 0, OItemId, "UInt")

            tabIndex := NumGet(lParam + 0, OCtlId, "UInt")
            tabName := this.tabNames[tabIndex + 1]

            textColor := this.themeObj.RGB2BGR("0x" . this.themeObj.GetColor(isSelected ? "textLight" : "text"))
            bgColor := this.themeObj.RGB2BGR("0x" . this.themeObj.GetColor("background"))
            hdc := NumGet(lParam + 0, OHDC, "Ptr")

            bgRect := BufferAlloc(16, 0)

            DllCall("CopyRect", "Ptr", bgRect, "Ptr", lParam + ORect)

            rectL := NumGet(bgRect.Ptr, 0, "Int")
            rectT := NumGet(bgRect.Ptr, 4, "Int")
            rectR := NumGet(bgRect.Ptr, 8, "Int")
            rectB := NumGet(bgRect.Ptr, 12, "Int")

            DllCall("InflateRect", "Ptr", bgRect, "Int", 3, "Int", 3)

            rectL := NumGet(bgRect.Ptr, 0, "Int")
            rectT := NumGet(bgRect.Ptr, 4, "Int")
            rectR := NumGet(bgRect.Ptr, 8, "Int")
            rectB := NumGet(bgRect.Ptr, 12, "Int")

            brush := DllCall("CreateSolidBrush", "UInt", textColor, "Ptr")
            DllCall("FillRect", "Ptr", hdc, "Ptr", bgRect, "Ptr", brush)

            DllCall("InflateRect", "Ptr", lParam + ORect, "Int", -3, "Int", 0)
            DllCall("Gdi32.dll\SetBkMode", "Ptr", hdc, "UInt", 0)
            DllCall("Gdi32.dll\SetTextColor", "Ptr", hdc, "UInt", textColor)
            DllCall("DrawText", "Ptr", hdc, "Str", tabName, "Int", StrLen(tabName), "Ptr", lParam + ORect, "UInt", DT_LEFT | DT_END_ELLIPSIS | DT_VCENTER )
            
            return true
        }
    }

    ; TODO: Move everything that needs this into GuiControlBase instances
    SubclassControl(hctl, callback, data := 0) {
        static controlCB := Map()

        If controlCB.Has(hctl) {
            DllCall("RemoveWindowSubclass", "Ptr", hctl, "Ptr", controlCB[hctl], "Ptr", hctl)
            DllCall("GlobalFree", "Ptr", controlCB[hctl], "Ptr")
            controlCB.Delete(hctl)

            If (callback = "") {
                return true
            }
        }

        if (!DllCall("IsWindow", "Ptr", hctl, "UInt")) {
            return false
        }

        if (!(CB := CallbackCreate(callback, , 6))) {
            return false
        }
            
        If !DllCall("SetWindowSubclass", "Ptr", hctl, "Ptr", CB, "Ptr", hctl, "Ptr", data) {
            return (DllCall("GlobalFree", "Ptr", CB, "Ptr") & 0)
        }
            
        return (controlCB[hctl] := CB)
    }

    AddCheckBox(checkboxText, ctlName, checked, inGroupBox := true, callback := "", check3 := false, position := "") {
        if (callback == "") {
            callback := "On" . ctlName
        }

        hasPos := position != ""

        width := this.windowSettings["contentWidth"]

        if (!hasPos) {
            position := "xs"
        }
        

        if (inGroupBox) {
            if (!hasPos) {
                position .= "+" . this.margin
            }
            
            width -= this.margin * 2
        }

        if (!hasPos) {
            position .= " y+m"
        }

        if (check3) {
            checked .= " Check3"
        }

        chk := this.guiObj.AddCheckBox(position . " w" . width . " v" . ctlName . " checked" . checked, checkboxText)
        chk.OnEvent("Click", callback)
        return chk
    }

    OnReload(btn, info) {
        this.app.RestartApp()
    }

    ShowTitleMenu() {

    }

    AddEdit(name, defaultValue := "", options := "", width := "") {
        if (width == "") {
            width := this.windowSettings["contentWidth"]
        }

        opts := "x" . this.margin . " w" . width . " -VScroll v" . name . " c" . this.themeObj.GetColor("editText") . " " . options
        return this.guiObj.AddEdit(opts, defaultValue)
    }

    UpdateStatusIndicator() {
        if (this.showStatusIndicator) {
            this.titlebar.statusIndicator.UpdateStatusIndicator(this.GetStatusInfo(), this.StatusWindowIsOnline() ? "status" : "statusOffline")
        }
    }

    StatusWindowIsOnline() {
        return false
    }

    GetStatusInfo() {
        return Map("name", "", "photo", "")
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
        hwnd := 0

        if (this.guiObj && !this.isClosed) {
            return this.guiObj.Hwnd
        }
    }

    GetTitle(title) {
        return title
    }

    Show() {
        this.Start()
        
        if (this.showTitlebar) {
            titleText := this.showTitle ? this.GetTitle(this.title) : ""
            this.titlebar := this.Add("TitlebarControl", "", titleText, this.titleIsMenu, this.iconSrc)
        }

        this.Controls()
        this.AddButtons()

        return this.End()
    }

    Create() {      
        this.guiObj := Gui.New(this.windowOptions, this.GetTitle(this.title), this)
        this.guiObj.BackColor := this.themeObj.GetColor("background")
        this.guiObj.MarginX := this.margin
        this.guiObj.MarginY := this.margin

        if (this.frameShadow) {
            this.themeObj.SetFrameShadow(this.guiObj.Hwnd)
        }

        this.SetFont()

        this.guiObj.OnEvent("Close", "OnClose")
        this.guiObj.OnEvent("Escape", "OnEscape")
        this.guiObj.OnEvent("Size", "OnSize")
    }

    Start() {
        if (this.owner != "") {
            this.app.GuiManager.AddToParent(this.windowKey, this.owner)
	    }
    }

    Controls() {
    }

    AddButtons() {
    }

    End() {
        width := this.width ? this.width : (this.windowSettings["contentWidth"] + (this.margin * 2))
        windowSize := "w" . width
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
        } else if (this.openAtCtl) {
            this.openAtCtl.GetPos(ctlX, ctlY, ctlW, ctlH)
            this.openAtCtl.Gui.GetClientPos(clientX, clientY)
            windowX := clientX
            windowY := clientY

            if (this.openAtCtlSide == "right") {
                windowX += ctlX + ctlW
                windowY += ctlY
            } else if (this.openAtCtlSide == "bottom") {
                windowX += ctlX
                windowY += ctlY + ctlH
            }

            windowSize .= " x" . windowX . " y" . windowY
        }

        this.guiObj.Show(windowSize . " " . this.showOptions)

        if (this.lvHeaderHwnd) {
            WinRedraw("ahk_id " . this.lvHeaderHwnd)
        }

        if (!this.positionAtMouseCursor && this.showInNotificationArea) {
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
        result := this

        if (this.waitForResult) {
            Loop
            {
                If (this.result || this.canceled) {
                    Break
                }

                Sleep(50)
            }

            submittedData := this.Submit()
            result := this.ProcessResult(this.result, submittedData)
            this.Close()
        }

        return result
    }

    ProcessResult(result, submittedData := "") {
        return result
    }

    Minimize() {
        WinMinimize("ahk_id " . this.guiObj.Hwnd)
    }

    Maximize() {
        WinMaximize("ahk_id " . this.guiObj.Hwnd)
    }

    Restore() {
        WinRestore("ahk_id " . this.guiObj.Hwnd)
    }

    Submit(hide := true) {
        submittedData := ""

        if (!this.isClosed) {
            submittedData := this.guiObj.Submit(hide)
        }

        return submittedData
    }

    Close(submit := false) {
        if (submit && !this.isClosed) {
            this.guiObj.Submit(true)
            this.isClosed := true
        } else if (!this.isClosed) {
            this.guiObj.Hide()
        }

        if (!this.isClosed && WinExist("ahk_id " . this.guiObj.Hwnd)) {
            WinClose("ahk_id " . this.guiObj.Hwnd)
        } else {
            this.Destroy()
        }
    }

    Destroy() {
        if (this.tabsHwnd) {
            OnMessage(0x002B, this.tabsCustomDrawCallback, 0)
        }

        if (this.owner) {
            this.app.GuiManager.ReleaseFromParent(this.windowKey)
        }

        this.Cleanup()

        if (!this.isClosed) {
            this.isClosed := true
            this.guiObj.Destroy()
        }
    }

    Cleanup() {
        this.app.GuiManager.container.Delete(this.windowKey)
        ; Extend to clear any global variables used
    }

    /*
        UTILITIES
    */

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

    ButtonWidth(numberOfButtons, availableWidth := 0) {
        if (availableWidth == 0) {
            availableWidth := this.windowSettings["contentWidth"]
        }

        marginWidth := (numberOfButtons <= 1) ? 0 : (this.margin * (numberOfButtons - 1))
        return (availableWidth - marginWidth) / numberOfButtons
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

    /*
        EVENT HANDLERS
    */

    OnClose(guiObj) {
        if (!this.isClosed) {
            this.Destroy()
        }
        
        return true
    }

    OnEscape(guiObj) {
        if (!this.isClosed) {
            this.Destroy()
        }

        return true
    }

    OnSize(guiObj, minMax, width, height) {
        if (this.showTitlebar) {
            this.titlebar.OnSize(minMax, width, height)
        }
    }
}
