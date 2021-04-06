class ManageWindowBase extends GuiBase {
    listViewColumns := Array()
    numSelected := 0
    lvCount := 0
    frameShadow := false
    checkboxes := false

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

    AddManageList() {
        countOption := this.lvCount ? "Count" . this.lvCount : ""
        checkOption := this.checkboxes ? " Checked" : ""
        lv := this.AddListView("ListView", countOption . " Section +Report -Multi" . checkOption)
        this.SetupManageEvents(lv)
        this.PopulateListView()
        return lv
    }

    SetupManageEvents(lv) {
        lv.OnEvent("ContextMenu", "ShowListViewContextMenu")
    }

    ShowListViewContextMenu(lv, item, isRightClick, X, Y) {

    }

    PopulateListView(focusedItem := 1) {

    }

    OnSize(guiObj, minMax, width, height) {
        super.OnSize(guiObj, minMax, width, height)
        
        if (minMax == -1) {
            return
        }

        this.AutoXYWH("wh", ["ListView"])

        for index, col in this.listViewColumns {
            this.guiObj["ListView"].ModifyCol(index, "AutoHdr")
        }
    }
}
