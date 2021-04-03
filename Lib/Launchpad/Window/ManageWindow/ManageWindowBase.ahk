class ManageWindowBase extends GuiBase {
    sidebarWidth := 85
    listViewColumns := Array()
    numSelected := 0
    lvCount := 0
    frameShadow := false
    checkboxes := false

    Controls() {
        super.Controls()
        this.AddManageList()
        this.AddBottomControls()
        this.AddSidebarControls()
    }

    AddSidebarControls() {

    }

    AddBottomControls() {

    }

    AddManageButton(name, position, symbol, primary := false) {
        options := "v" . name . " " . position
        options .= " w35 h35"
        return this.Add("ButtonControl", options, symbol, "On" . name, primary ? "managePrimary" : "manage")
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

    }

    PopulateListView(focusedItem := 1) {

    }

    AddToolbar() {
        ImageList := IL_Create(9)
        IL_Add(ImageList, "shell32.dll", 1)
        IL_Add(ImageList, "shell32.dll", 4)
        IL_Add(ImageList, "shell32.dll", 296)
        IL_Add(ImageList, "shell32.dll", 133)
        IL_Add(ImageList, "shell32.dll", 298)
        IL_Add(ImageList, "shell32.dll", 297)
        IL_Add(ImageList, "shell32.dll", 320)

        buttonList := "
        (LTrim
            New
            Open
            Save
            Save As
            Reload From Disk
            -
            Activate in Launchpad,, DISABLED
            -
            Flush Cache
        )"

        return this.CreateToolbar("OnToolbar", ImageList, buttonList)
    }

    OnToolbar(hWnd, Event, Text, Pos, Id) {
        If (Event != "Click") {
            Return
        }

        If (Text == "New") {

        } Else If (Text == "Open") {

        } Else If (Text == "Save") {

        } Else If (Text == "Save As") {

        } Else If (Text == "Reload From Disk") {

        } Else If (Text == "Activate in Launchpad") {

        } Else If (Text == "Flush Cache") {

        }
    }

    OnSize(guiObj, minMax, width, height) {
        super.OnSize(guiObj, minMax, width, height)
        
        if (minMax == -1) {
            return
        }

        this.AutoXYWH("wh", ["ListView"])

        if (this.hToolbar) {
            this.guiObj["Toolbar"].Move(,,width)
        }

        for index, col in this.listViewColumns {
            this.guiObj["ListView"].ModifyCol(index, "AutoHdr")
        }
    }
}
