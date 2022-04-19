class GuiBase {
    container := ""
    app := ""
    guiObj := ""
    guiId := ""
    themeObj := ""
    eventMgr := ""
    owner := ""
    parent := ""
    windowSettingsKey := ""
    windowSettings := Map()
    windowOptions := ""
    margin := ""
    buttons := []
    isClosed := false
    activeTooltip := false
    lv := ""
    lvHeaderHwnd := 0
    listViewColumns := []
    tabsHwnd := ""
    tabNames := []
    showOptions := ""
    openAtCtl := ""
    result := ""
    canceled := false
    statusIndicator := ""
    titlebar := ""
    width := ""
    height := ""
    isShown := false
    config := ""
    merger := ""

    GetDefaultConfig(container, config) {
        return Map(
            "id", Type(this),
            "titlebar", true,
            "waitForResult", false,
            "titleIsMenu", false,
            "showIcon", true,
            "showTitle", true,
            "showClose", true,
            "showMinimize", true,
            "showMaximize", false,
            "title", "",
            "icon", "",
            "frameShadow", true,
            "openAtCtlSide", "bottom", ; Bottom or right
            "saveWindowState", false,
            "positionAtMouseCursor", false,
            "openWindowWithinScreenBounds", true,
            "showInNotificationArea", false,
            "showStatusIndicator", false
        )
    }

    __New(container, themeObj, config) {
        this.container := container
        this.app := container.GetApp()
        this.themeObj := themeObj
        this.merger := container.Get("merger.list")
        this.config := this.MergeConfig(config, container)

        if (!this.config.Has("id") || !this.config["id"]) {
            throw AppException("id key not specified in GUI config")
        }

        if (this.config.Has("ownerOrParent") && this.config["ownerOrParent"]) {
            if (this.config.Has("child") && this.config["child"]) {
                this.parent := container.Get("manager.gui").DereferenceGui(this.config.Has("ownerOrParent"))
            } else {
                this.owner := container.Get("manager.gui").DereferenceGui(this.config["ownerOrParent"])
            }
        }

        extraOptions := Map()

        if (this.config["titlebar"]) {
            extraOptions["Caption"] := false
            extraOptions["Border"] := true
        }

        if (this.owner != "") {
            extraOptions["Owner" . this.owner.Hwnd] := true
        }

        if (this.windowSettingsKey == "") {
            this.windowSettingsKey := Type(this)
        }
        
        this.windowSettings := themeObj.GetWindowSettings(this.windowSettingsKey)
        this.windowOptions := themeObj.GetWindowOptionsString(this.windowSettingsKey, extraOptions)

        options := this.windowSettings["options"]

        if (options.Has("Resize") && options["Resize"]) {
            this.config["showMaximize"] := true
        }

        if (this.owner || options.Has("Popup") && options["Popup"]) {
            this.config["showMinimize"] := false
        }

        this.margin := this.windowSettings["spacing"]["margin"]
        this.guiId := this.config["id"]

        this.RegisterCallbacks()
        this.Create()
    }

    MergeConfig(config, container) {
        winConfig := this.GetDefaultConfig(container, config)

        for key, val in config {
            winConfig[key] := val
        }

        return winConfig
    }

    RegisterCallbacks() {
        guiId := "Gui" . this.guiId

        this.app.Service("manager.event")
            .Register(Events.MOUSE_MOVE, guiId, ObjBindMethod(this, "OnMouseMove"))
            .Register(Events.WM_NCCALCSIZE, guiId, ObjBindMethod(this, "OnCalcSize"))
            .Register(Events.WM_NCACTIVATE, guiId, ObjBindMethod(this, "OnActivate"))
            .Register(Events.WM_NCHITTEST, guiId, ObjBindMethod(this, "OnHitTest"))
    }

    OnCheckbox(chk, info) {
        ; TODO: Remove the need for a dummy callback
    }

    __Delete() {
        if (this.app) {
            this.app.Service("manager.event").Unregister(Events.MOUSE_MOVE, "Gui" . this.guiId)
            this.app.Service("manager.event").Unregister(Events.WM_NCCALCSIZE, "Gui" . this.guiId)
            this.app.Service("manager.event").Unregister(Events.WM_NCACTIVATE, "Gui" . this.guiId)
            this.app.Service("manager.event").Unregister(Events.WM_NCHITTEST, "Gui" . this.guiId)
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
        return %ctlClass%(this, options, params*)
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

        if hwnd != A_ScriptHwnd && hwnd != this.GetHwnd() {
            return
        }

        guiHwnd := ""
        
        try {
            guiHwnd := this.guiObj.Hwnd
        } catch Any {
            guiHwnd := ""
        }

        if (!guiHwnd) {
            return
        }
        
        WinGetPos(&gX, &gY, &gW, &gH, "ahk_id " . this.guiObj.Hwnd)

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
            MouseGetPos(,,, &ctlHwnd, 2)
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

    AddText(text, options := "", font := "normal", fontOptions := "") {
        this.SetFont(font, fontOptions)
        ctl := this.guiObj.AddText(options . " +0x200", text)
        this.SetFont()
        return ctl
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
        if (this.config["showStatusIndicator"]) {
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

    GetHwnd() {
        hwnd := 0

        if (this.guiObj && !this.isClosed) {
            return this.guiObj.Hwnd
        }
    }

    GetTitle() {
        return this.config["title"]
    }

    Show(windowState := "") {
        result := this

        if (!this.isShown) {
            this.Start()
            
            if (this.config["titlebar"]) {
                titleText := this.config["showTitle"] ? this.GetTitle() : ""
                this.titlebar := this.Add("TitlebarControl", "", titleText, this.config["titleIsMenu"], this.config["showIcon"] ? this.config["icon"] : "")
            }

            this.Controls()
            this.AddButtons()

            this.isShown := true
            result := this.End(windowState)
        }
        
        return result
    }

    Create() {      
        this.guiObj := Gui(this.windowOptions, this.GetTitle(), this)
        this.guiObj.BackColor := this.themeObj.GetColor("background")
        this.guiObj.MarginX := this.margin
        this.guiObj.MarginY := this.margin

        if (this.config["frameShadow"]) {
            this.themeObj.SetFrameShadow(this.guiObj.Hwnd)
        }

        this.SetFont()

        this.guiObj.OnEvent("Close", "OnClose")
        this.guiObj.OnEvent("Escape", "OnEscape")
        this.guiObj.OnEvent("Size", "OnSize")
    }

    Start() {
    }

    Controls() {
    }

    AddButtons() {
    }

    End(windowState := "") {
        width := this.windowSettings["contentWidth"] + (this.margin * 2)

        if (this.width) {
            width := this.width
        }

        windowSize := "w" . width

        height := ""

        if (this.height) {
            height := this.height
            windowSize .= " h" . height
        }

        newW := width
        newH := height

        MonitorGetWorkArea(, &monitorL, &monitorT, &monitorR, &monitorB)

        if (this.config["positionAtMouseCursor"]) {    
            CoordMode("Mouse", "Screen")
            MouseGetPos(&windowX, &windowY)
            CoordMode("Mouse")
            windowX -= width/2
            windowSize .= " x" . windowX . " y" . windowY
        } else if (this.config["showInNotificationArea"]) {
            this.guiObj.GetPos(,, &guiW, &guiH)
            windowX := monitorR - this.margin - width
            windowY := monitorB - this.margin - guiH
            windowSize .= " x" . windowX . " y" . windowY
        } else if (this.openAtCtl) {
            this.openAtCtl.GetPos(&ctlX, &ctlY, &ctlW, &ctlH)
            this.openAtCtl.Gui.GetClientPos(&clientX, &clientY)
            windowX := clientX
            windowY := clientY

            if (this.config["openAtCtlSide"] == "right") {
                windowX += ctlX + ctlW
                windowY += ctlY
            } else if (this.config["openAtCtlSide"] == "bottom") {
                windowX += ctlX
                windowY += ctlY + ctlH
            }

            windowSize .= " x" . windowX . " y" . windowY
        } else if (this.config["saveWindowState"] && windowState && windowState.Count) {
            if (windowState.Has("x")) {
                windowSize .= " x" . windowState["x"]
            }

            if (windowState.Has("y")) {
                windowSize .= " y" . windowState["y"]
            }

            if (windowState.Has("w")) {
                newW := windowState["w"]
            }

            if (windowState.Has("h")) {
                newH := windowState["h"]
            }
        }

        this.guiObj.Show(windowSize . " " . this.showOptions)

        if (newH != height || newW != width) {
            this.guiObj.Move(,, newW, newH)
        }

        transColorVal := this.themeObj.GetColor("transColor")
        if (transColorVal != "") {
            WinSetTransColor(transColorVal, "ahk_id " . this.guiObj.Hwnd)
        }

        if (!this.config["positionAtMouseCursor"] && this.config["showInNotificationArea"]) {
            this.guiObj.GetPos(,, &guiW, &guiH)
            windowX := monitorR - this.margin - guiW
            windowY := monitorB - this.margin - guiH
            this.guiObj.Move(windowX, windowY)
        }

        this.OnShow(windowState)

        result := this

        if (this.config["waitForResult"]) {
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

    OnShow(windowState := "") {
        

        if (this.lvHeaderHwnd) {
            WinRedraw("ahk_id " . this.lvHeaderHwnd)
        }

        this.AdjustWindowPosition()
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
            this.app.Service("manager.gui").StoreWindowState(this)
            WinClose("ahk_id " . this.guiObj.Hwnd)
        } else {
            this.Destroy()
        }

        this.app.Service("manager.gui").CleanupWindow(this.guiId)
    }

    Destroy() {
        if (!this.isClosed && this.config["saveWindowState"]) {
            this.app.Service("manager.gui").StoreWindowState(this)
        }

        if (this.owner) {
            this.app.Service("manager.gui").ReleaseFromParent(this.guiId)
        }

        this.Cleanup()

        if (!this.isClosed) {
            this.isClosed := true
            this.guiObj.Destroy()
        }
    }

    Cleanup() {
        this.app.Service("manager.gui").UnloadComponent(this.guiId)
        ; Extend to clear any global variables used
    }

    /*
        UTILITIES
    */

    AdjustWindowPosition() {
        this.guiObj.GetPos(&guiX, &guiY, &guiW, &guiH)

        if (this.config["openWindowWithinScreenBounds"]) {
            ; Check which monitor the user completed the last action on and use that
            monitorId := MonitorGetPrimary()
            MonitorGetWorkArea(monitorId, &screenL, &screenT, &screenR, &screenB)

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

        for , dim in optionSplit {
            if (RegExMatch(options, "i)" . dim . "\s*\K[\d.-]+", &f%dim%)) {
                f%dim% := f%dim%[]
            } else {
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
        ctlObj.GetPos(&ix, &iy, &iw, &ih)
        return Map("x", ix, "y", iy, "w", iw, "h", ih)
    }

    ; Originally based on https://www.autohotkey.com/boards/viewtopic.php?t=1079
    AutoXYWH(options, controls) {   
        static controlInfo := Map()

        if (options == "reset") {
            controlInfo := Map()
            return 
        }

        for , ctl in controls {
            if (!IsObject(ctl)) {
                ctl := this.guiObj[ctl]
            }

            if (!controlInfo.Has(ctl.Hwnd)) {
                info := this.GetControlDimensions(ctl)
                info["redraw"] := InStr(options, "*")
                info["optionSplit"] := StrSplit(RegExReplace(options, "i)[^xywh]"))
                info := this.ParseDimensions(options, info)
                info := this.GetParentXY(ctl, options, info)
                this.guiObj.GetPos(,, &guiWidth, &guiHeight)
                info["gw"] := guiWidth
                info["gh"] := guiHeight
                controlInfo[ctl.Hwnd] := info
            } else {
                info := controlInfo[ctl.Hwnd]
                this.guiObj.GetPos(,, &guiWidth, &guiHeight)
                dgx := dgw := guiWidth - info["gw"]
                dgy := dgh := guiHeight - info["gh"]
                ctl.GetPos(&newX, &newY, &newW, &newH)

                for i, dim in controlInfo[ctl.Hwnd]["optionSplit"] {
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

            VarSetStrCapacity(&RECT, 16)
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
        if (this.config["titlebar"]) {
            this.titlebar.OnSize(minMax, width, height)
        }
    }
}
