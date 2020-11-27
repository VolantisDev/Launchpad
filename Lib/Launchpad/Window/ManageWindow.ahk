class ManageWindow extends WindowBase {
    windowOptions := "+Resize MinSize380x380"
    contentWidth := 510
    listViewHeight := 300
    sidebarWidth := 85
    listViewColumns := Array("Order", "Game", "Launcher")
    launcherFile := ""

    __New(app, launcherFile := "", owner := "", windowKey := "") {
        if (launcherFile == "") {
            launcherFile := app.Config.LauncherFile
        }

        this.launcherFile := launcherFile

        super.__New(app, "Manage", owner, windowKey)
    }

    GetTitle(title) {
        return super.GetTitle(this.launcherFile . " - " . title)
    }

    Controls() {
        super.Controls()

        listViewWidth := this.contentWidth - this.sidebarWidth - this.margin
        lv := this.guiObj.AddListView("vListView w" . listViewWidth . " h" . this.listViewHeight . " Section +Report -Multi +LV0x4000", this.listViewColumns)

        buttonWidth := this.sidebarWidth - (this.margin * 2)

        gbY := this.margin * 2

        this.guiObj.AddGroupBox("vLauncherGroup ys+" . this.margin . " w" . this.sidebarWidth . " r5 Section", "Launcher")
        this.guiObj.AddButton("vAddButton xs+" . this.margin . " ys+" . gbY . " w" . buttonWidth, "Add")
        this.guiObj.AddButton("vEditButton xs+" . this.margin . " w" . buttonWidth, "Edit")
        this.guiObj.AddButton("vRemoveButton xs+" . this.margin . " w" . buttonWidth, "Remove")
        this.guiObj.AddButton("vMoveUpButton xs+" . this.margin . " w" . buttonWidth, "Move Up")
        this.guiObj.AddButton("vMoveDownButton xs+" . this.margin . " w" . buttonWidth, "Move Down")
        
        this.guiObj.AddGroupBox("vSortGroup xs y+m w" . this.sidebarWidth . " r2 Section", "Sort All")
        this.guiObj.AddButton("vByNameButton xs+" . this.margin . " ys+" . gbY . " w" . buttonWidth, "By Name")
        this.guiObj.AddButton("vByTypeButton xs+" . this.margin . " w" . buttonWidth, "By Type")

        this.guiObj.AddButton("vExitButton xs y+m w" . this.sidebarWidth . " h30", "E&xit")
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
        if (minMax == -1) {
            return
        }

        this.AutoXYWH("wh", ["ListView"])
        this.AutoXYWH("x*", ["LauncherGroup", "SortGroup"])
        this.AutoXYWH("x", ["AddButton", "EditButton", "RemoveButton", "MoveUpButton", "MoveDownButton", "ByNameButton", "ByTypeButton"])
        this.AutoXYWH("xy*", ["ExitButton"])

        if (this.hToolbar) {
            this.guiObj["Toolbar"].Move(,,width)
        }
    }
}
