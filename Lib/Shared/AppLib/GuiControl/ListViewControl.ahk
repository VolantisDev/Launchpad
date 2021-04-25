class ListViewControl extends GuiControlBase {
    headerHwnd := 0
    columns := []
    rowData := Map()
    dataCallback := ""
    highlightRowCallback := ""
    rowOpts := []
    keyCol := 2
    imgListCallback := ""
    imgListS := ""
    imgListL := ""

    CreateControl(columns, dataCallback, imgListCallback := "", initCallback := "", highlightRowCallback := "") {
        global LVM_GETHEADER
        super.CreateControl(false)
        columns.InsertAt(this.keyCol, "")

        this.columns := columns
        this.dataCallback := dataCallback
        this.imgListCallback := imgListCallback
        this.highlightRowCallback := highlightRowCallback

        lvH := 400

        if (this.guiObj.windowSettings.Has("listViewHeight") && this.guiObj.windowSettings["listViewHeight"]) {
            lvH := this.guiObj.windowSettings["listViewHeight"]
        } 

        defaults := []
        defaults.Push("w" . this.guiObj.windowSettings["contentWidth"])
        defaults.Push("h" . lvH)
        defaults.Push("C" . this.guiObj.themeObj.GetColor("text"))
        defaults.Push("Background" . this.guiObj.themeObj.GetColor("background"))
        defaults.Push("+LV" . LVS_EX_LABELTIP)
        defaults.Push("+LV" . LVS_EX_DOUBLEBUFFER)
        defaults.Push("+LV" . LVS_EX_FLATSB)
        defaults.Push("-E0x200")
        ;defaults.Push("+LV" . LVS_EX_AUTOSIZECOLUMNS)

        opts := this.SetDefaultOptions(this.options, defaults)
        this.ctl := this.guiObj.guiObj.AddListView(this.GetOptionsString(opts), this.columns)
        this.headerHwnd := SendMessage(LVM_GETHEADER, 0, 0,, "ahk_id " . this.ctl.Hwnd) + 0
        this.SubclassControl(this.ctl.Hwnd, ObjBindMethod(this, "OnListViewDraw"))
        this.ctl.ModifyCol(2, 0)
        this.ctl.ModifyCol(this.columns.Length, "AutoHdr")

        if (initCallback) {
            this.guiObj.%initCallback%(this)
        }

        if (dataCallback) {
            this.UpdateListView()
        }

        return this.ctl
    }

    GetSelected(type := "", getKeys := false) {
        selected := []
        rowNum := 0

        Loop {
            rowNum := this.ctl.GetNext(rowNum, type)

            if !rowNum {
                break
            }

            val := getKeys ? this.GetRowKey(rowNum) : rowNum

            selected.Push(val)
        }

        return selected
    }

    UpdateListView(maintainSelections := true) {
        selected := []
        focused := []
        checked := []

        if (maintainSelections) {
            selected := this.GetSelected()
            focused := this.GetSelected("Focused")
            checked := this.GetSelected("Checked")
        }

        this.imgListS := ""
        this.imgListL := ""

        if (this.imgListCallback) {
            callback := this.imgListCallback
            this.imgListS := this.guiObj.%callback%(this, false)
            this.imgListL := this.guiObj.%callback%(this, true)
            this.ctl.SetImageList(this.imgListS, 1)
            this.ctl.SetImageList(this.imgListL, 0)
        }

        callback := this.dataCallback
        this.rowData := this.guiObj.%callback%(this)

        this.ctl.Delete()

        idx := 0

        for key, data in this.rowData {
            idx++
            rowOpts := []
            highlight := false

            if (this.highlightRowCallback) {
                callback := this.highlightRowCallback
                highlight := this.guiObj.%callback%(key, data)
            }

            if (highlight) {
                data[1] .= "*"
                ; TODO: Handle row highlighting
            }

            for index, rowNum in selected {
                if (idx == rowNum) {
                    rowOpts.Push("Select")
                }
            }

            for index, rowNum in focused {
                if (idx == rowNum) {
                    rowOpts.Push("Focus")
                }
            }

            for index, rowNum in checked {
                if (idx == rowNum) {
                    rowOpts.Push("Check")
                }
            }

            if (this.imgListS) {
                rowOpts.Push("Icon" . idx)
            }

            data.InsertAt(this.keyCol, key)
            opts := this.SetDefaultOptions(rowOpts, this.rowOpts)
            this.ctl.Add(this.GetOptionsString(opts), data*)
        }

        this.ctl.ModifyCol(1, "Sort")
        this.ResizeColumns()
    }

    UpdateRow(rowNum, data, opts := "") {
        key := this.GetRowKey(rowNum)
        this.ctl.Modify(rowNum, opts, data*)
    }

    GetRowKey(rowNum) {
        return this.ctl.GetText(rowNum, this.keyCol)
    }

    ResizeColumns() {
        if (this.columns.Length <= 2) {
            this.ctl.GetPos(,, &ctlW)
            this.ctl.ModifyCol(1, ctlW)
            this.ctl.ModifyCol(2, 0)
        } else {
            for index, col in this.columns {
                val := (index == this.keyCol) ? 0 : "AutoHdr"
                this.ctl.ModifyCol(index, val)
            }
        }
    }

    OnSize(guiObj, minMax, width, height) {
        super.OnSize(guiObj, minMax, width, height)
        
        if (minMax == -1) {
            return
        }

        this.guiObj.AutoXYWH("wh", [this.ctl.Name])

        this.ResizeColumns()
    }

    OnListViewDraw(h, m, w, l, idSubclass, refData) {
        static WM_NOTIFY := 0x4E
        static WM_DESTROY := 0x02

        static NM_CUSTOMDRAW := -12

        static CDRF_DODEFAULT := 0x00000000
        static CDRF_SKIPDEFAULT := 0x00000004
        static CDRF_NOTIFYITEMDRAW := 0x00000020
        static CDRF_NOTIFYSUBITEMDRAW := 0x00000020
        static CDDS_PREPAINT := 0x00000001
        static CDDS_ITEMPREPAINT := 0x00010001
        static CDDS_SUBITEM := 0x00020000

        static CDIS_SELECTED := 0x0001
        static CDIS_GRAYED := 0x0002
        static CDIS_DISABLED := 0x0004
        static CDIS_CHECKED := 0x0008
        static CDIS_FOCUS := 0x0010
        static CDIS_DEFAULT := 0x0020
        static CDIS_HOT := 0x0040
        static CDIS_MARKED := 0x0080
        static CDIS_INDETERMINATE := 0x0100
        
        static OMsg := (2 * A_PtrSize)
        
        Critical

        if (m == WM_NOTIFY) {
            hwnd := NumGet(l + 0, 0, "UPtr")

            ; Handle ListView header
            if (hwnd == this.headerHwnd) {
                message := NumGet(l + 0, OMsg, "Int")
            
                if (message == NM_CUSTOMDRAW) {
                    ODrawStage := OMsg + 4 + (A_PtrSize - 4)
                    drawStage := NumGet(l + 0, ODrawStage, "UInt")
                    
                    if (drawStage == CDDS_ITEMPREPAINT) {
                        OHDC := ODrawStage + 4 + (A_PtrSize - 4)
                        this.PaintListViewHeader(l, OHDC)
                        return CDRF_SKIPDEFAULT
                    } else if (drawStage == CDDS_PREPAINT) {
                        return CDRF_NOTIFYITEMDRAW
                    }

                    return CDRF_DODEFAULT
                }
            }
        } else if (m == WM_DESTROY) {
            this.SubclassControl(h, "")
        }

        ; All messages not completely handled by the function must be passed to the DefSubclassProc:
        return DllCall("DefSubclassProc", "Ptr", h, "UInt", m, "Ptr", w, "Ptr", l, "Ptr")
    }

    SetViewMode(viewMode) {
        this.ctl.Opt("+" . viewMode)
    }

    PaintListViewHeader(l, OHDC) {
        static DT_LEFT := 0
        static DT_END_ELLIPSIS := 0x00008000
        static DT_VCENTER := 0x00000004
        static ORect := OHDC + 4 + (A_PtrSize - 4)
        static OItemSpec := OHDC + 16 + A_PtrSize

        textColor := this.guiObj.themeObj.RGB2BGR("0x" . this.guiObj.themeObj.GetColor("textListViewHeader"))
        bgColor := this.guiObj.themeObj.RGB2BGR("0x" . this.guiObj.themeObj.GetColor("background"))
        hdc := NumGet(l + 0, OHDC, "Ptr")
        rectL := NumGet(l + 0, ORect, "Int") + (this.guiObj.margin/2)
        rectT := NumGet(l + 0, ORect + 4, "Int")
        rectR := NumGet(l + 0, ORect + 8, "Int") - (this.guiObj.margin/2)
        rectB := NumGet(l + 0, ORect + 12, "Int")
        rect := BufferAlloc(16)
        NumPut("Int", rectL, "Int", rectT, "Int", rectR, "Int", rectB, rect)
        DllCall("Gdi32.dll\SetBkMode", "Ptr", hdc, "UInt", 0)
        brush := DllCall("CreateSolidBrush", "UInt", bgColor, "Ptr")
        DllCall("FillRect", "Ptr", hdc, "Ptr", rect, "Ptr", brush)
        item := NumGet(l + 0, OItemSpec, "Ptr")+1
        text := this.ctl.GetText(0, item)
        DllCall("Gdi32.dll\SetTextColor", "Ptr", hdc, "UInt", textColor)
        DllCall("DrawText", "Ptr", hdc, "Str", text, "Int", StrLen(text), "Ptr", rect, "UInt", DT_LEFT | DT_END_ELLIPSIS | DT_VCENTER)
    }
}
