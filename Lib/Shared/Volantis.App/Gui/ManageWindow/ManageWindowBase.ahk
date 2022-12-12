class ManageWindowBase extends GuiBase {
    listViewColumns := Array()
    lvCount := 0
    checkboxes := false
    listView := ""
    lvWidth := 0
    showDetailsPane := false
    detailsFields := []

    GetDefaultConfig(container, config) {
        defaults := super.GetDefaultConfig(container, config)
        defaults["frameShadow"] := false
        defaults["saveWindowState"] := true
        return defaults
    }

    Controls() {
        super.Controls()
        this.AddManageList()

        this.listView.ctl.GetPos(, &y,, &h)
        
        if (this.showDetailsPane) {
            selected := this.listView.GetSelected("", true)
            key := ""

            if (selected.Length > 0) {
                key := selected[1]
            }

            this.AddDetailsPane(y, key)
        }
        
        this.AddBottomControls(y + h + this.margin)
    }

    AddBottomControls(y) {

    }

    AddManageButton(name, position, symbol, primary := false, text := "") {
        width := 30
        options := "v" . name . " " . position . " h" . width
        
        if (text) {
            width += this.themeObj.CalculateTextWidth(text) + (this.margin*2)
        }

        options .= " w" . width
        drawConfig := Map()
        drawConfig["text"] := text
        return this.Add("ButtonControl", options, symbol, "On" . name, primary ? "managePrimary" : "manage", drawConfig)
    }

    GetViewMode() {
        return "Report"
    }

    AddManageList() {
        opts := ["vListView", "Section", "+" . this.GetViewMode(), "-Multi"]

        if (this.lvCount) {
            opts.Push("Count" . this.lvCount)
        }

        if (this.checkboxes) {
            opts.Push("Checked")
        }

        this.lvWidth := this.windowSettings["contentWidth"]

        if (this.showDetailsPane) {
            this.lvWidth := 250
            opts.Push("w" . this.lvWidth)
        }

        this.listView := this.Add("ListViewControl", opts, "", this.listViewColumns, "GetListViewData", "GetListViewImgList", "InitListView", "ShouldHighlightRow")
        this.listView.resizeOpts := "h"
        return this.listView
    }

    AddDetailsPane(key := "") {
        
    }

    UpdateDetailsPane(key := "") {

    }

    GetListViewData(lv) {

    }

    ShouldHighlightRow(key, data) {
        return false
    }

    GetListViewImgList(lv, large := false) {

    }

    UpdateListView(focusedRow := 0) {
        key := this.listView.GetSelected("", true, true)
        this.listView.UpdateListView(true)
        this.UpdateDetailsPane(key)
    }

    InitListView(lv) {
        lv.ctl.OnEvent("ContextMenu", "ShowListViewContextMenu")
        lv.ctl.OnEvent("DoubleClick", "OnDoubleClick")
        lv.ctl.OnEvent("Click", "OnClick")
        lv.ctl.OnEvent("ItemSelect", "OnItemSelect")
    }

    OnClick(LV, rowNum) {
        key := LV.GetText(rowNum, 2)
        
        if (this.showDetailsPane && key) {
            this.UpdateDetailsPane(key)
        }
    }

    OnItemSelect(LV, item, selected) {
        if (!selected) {
            this.UpdateDetailsPane()
        } else {
            key := LV.GetText(item, 2)
            this.UpdateDetailsPane(key)
        }
    }

    OnDoubleClick(LV, rowNum) {

    }

    ShowListViewContextMenu(lv, item, isRightClick, X, Y) {

    }

    OnSize(guiObj, minMax, width, height) {
        super.OnSize(guiObj, minMax, width, height)
        
        if (minMax == -1) {
            return
        }

        if (this.listView) {
            this.listView.OnSize(guiObj, minMax, width, height)
        }

        if (this.showDetailsPane && this.detailsFields.Length > 0) {
            this.AutoXYWH("w", this.detailsFields)
        }
    }
}
