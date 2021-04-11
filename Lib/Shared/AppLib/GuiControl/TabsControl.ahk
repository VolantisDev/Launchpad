class TabsControl extends GuiControlBase {
    ctlHwnd := 0
    tabs := []
    static TCS_OWNERDRAWFIXED := 0x2000

    CreateControl(tabs) {
        super.CreateControl(false)
        this.tabs := tabs

        defaults := []
        defaults.Push("w" . this.guiObj.windowSettings["contentWidth"])
        defaults.Push("C" . this.guiObj.themeObj.GetColor("text"))
        defaults.Push("Background" . this.guiObj.themeObj.GetColor("background"))
        defaults.Push("+0x100")
        defaults.Push("+" . TabsControl.TCS_OWNERDRAWFIXED)
        defaults.Push("x" . this.guiObj.margin)
        defaults.Push("y+" . this.guiObj.margin)

        opts := this.SetDefaultOptions(this.options, defaults)
        this.ctl := this.guiObj.guiObj.Add("Tab3", this.GetOptionsString(opts), this.tabs)
        this.ctlHwnd := this.ctl.Hwnd
        this.SubclassControl(this.ctl.Hwnd, ObjBindMethod(this, "OnTabsSubclass"))
        
        return this.ctl
    }

    __Delete() {
        if (this.ctlHwnd) {
            ;OnMessage(0x002B, this.tabsCustomDrawCallback, 0)
        }
    }

    OnTabsSubclass(h, m, w, l, idSubclass, refData) {
        static TCM_ADJUSTRECT := 0x1328
        static WM_DESTROY := 0x02
        static WM_PAINT := 0xF

        Critical

        static OMsg := A_PtrSize

        if (this.ctlHwnd == h && m == WM_PAINT) {
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

        if (ctlType == ODT_TAB && hwnd == this.guiObj.guiObj.Hwnd) {
            tabIndex := NumGet(lParam + 0, OCtlId, "UInt")
            isSelected := NumGet(lParam + 0, OItemId, "UInt")

            tabIndex := NumGet(lParam + 0, OCtlId, "UInt")
            tabName := this.tabNames[tabIndex + 1]

            textColor := this.guiObj.themeObj.RGB2BGR("0x" . this.guiObj.themeObj.GetColor(isSelected ? "textInactive" : "text"))
            bgColor := this.guiObj.themeObj.RGB2BGR("0x" . this.guiObj.themeObj.GetColor("background"))
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

    OnTabsAdjustRect(wParam, lParam, msg, hwnd) {
        
    }

    OnSize(guiObj, minMax, width, height) {
        super.OnSize(guiObj, minMax, width, height)
        
        if (minMax == -1) {
            return
        }

        this.guiObj.AutoXYWH("wh", [this.ctl.Name])
        this.ResizeColumns()
    }
}
