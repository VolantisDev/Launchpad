class ManageWindowBase extends GuiBase {
    listViewColumns := Array()
    lvCount := 0
    frameShadow := false
    checkboxes := false
    listView := ""
    saveWindowState := true
    showDetailsPane := false

    Controls() {
        super.Controls()
        this.AddManageList()
        this.AddBottomControls()
    }

    AddBottomControls() {

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

        if (this.showDetailsPane) {
            opts.Push("w" . ((this.windowSettings["contentWidth"] - this.margin)/2))
        }

        this.listView := this.Add("ListViewControl", opts, "", this.listViewColumns, "GetListViewData", "GetListViewImgList", "InitListView", "ShouldHighlightRow")
        return this.listView
    }

    GetListViewData(lv) {

    }

    ShouldHighlightRow(key, data) {
        return false
    }

    GetListViewImgList(lv, large := false) {

    }

    UpdateListView(focusedRow := 0) {
        this.listView.UpdateListView(focusedRow)
    }

    InitListView(lv) {
        lv.ctl.OnEvent("ContextMenu", "ShowListViewContextMenu")
        lv.ctl.OnEvent("DoubleClick", "OnDoubleClick")
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
    }
}
