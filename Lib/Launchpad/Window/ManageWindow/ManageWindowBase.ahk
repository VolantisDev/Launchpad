class ManageWindowBase extends GuiBase {
    listViewColumns := Array()
    lvCount := 0
    frameShadow := false
    checkboxes := false
    listView := ""
    lvWidth := 0
    saveWindowState := true
    showDetailsPane := false

    Controls() {
        super.Controls()
        this.AddManageList()

        if (this.showDetailsPane) {
            selected := this.listView.GetSelected("", true)
            key := ""

            if (selected.Length > 0) {
                key := selected[1]
            }

            this.AddDetailsPane(key)
        }

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

        this.lvWidth := this.windowSettings["contentWidth"]

        if (this.showDetailsPane) {
            this.lvWidth := (this.lvWidth - this.margin) / 2
            opts.Push("w" . this.lvWidth)
        }

        this.listView := this.Add("ListViewControl", opts, "", this.listViewColumns, "GetListViewData", "GetListViewImgList", "InitListView", "ShouldHighlightRow")
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
        this.listView.UpdateListView(focusedRow)
    }

    InitListView(lv) {
        lv.ctl.OnEvent("ContextMenu", "ShowListViewContextMenu")
        lv.ctl.OnEvent("DoubleClick", "OnDoubleClick")
        lv.ctl.OnEvent("Click", "OnClick")
        ; TODO: Change Click handler to ItemSelect once I figure out why that isn't working
    }

    OnClick(LV, rowNum) {
        key := LV.GetText(rowNum, 2)
        
        if (this.showDetailsPane) {
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
    }
}
