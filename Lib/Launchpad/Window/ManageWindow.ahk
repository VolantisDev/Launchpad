class ManageWindow extends LaunchpadGuiBase {
    sidebarWidth := 85
    listViewColumns := Array("Order", "Game", "Launcher")
    launcherFile := ""

    __New(app, launcherFile := "", windowKey := "", owner := "", parent := "") {
        if (launcherFile == "") {
            launcherFile := app.Config.LauncherFile
        }

        InvalidParameterException.CheckTypes("ManageWindow", "launcherFile", launcherFile, "")
        this.launcherFile := launcherFile
        super.__New(app, "Manage", windowKey, owner, parent)
    }

    GetTitle(title) {
        return super.GetTitle(this.launcherFile . " - " . title)
    }

    Controls() {
        super.Controls()

        listViewWidth := this.windowSettings["contentWidth"] - this.sidebarWidth - this.margin
        lv := this.guiObj.AddListView("vListView w" . listViewWidth . " h" . this.windowSettings["listViewHeight"] . " Section +Report -Multi +LV0x4000", this.listViewColumns)

        buttonWidth := this.sidebarWidth - (this.margin * 2)

        gbY := this.margin * 2

        this.guiObj.AddGroupBox("vLauncherGroup ys+" . this.margin . " w" . this.sidebarWidth . " r6.5 Section", "Launcher")
        this.AddButton("vAddButton xs+" . this.margin . " ys+" . gbY . " w" . buttonWidth . " h25", "Add")
        this.AddButton("vEditButton xs+" . this.margin . " y+m w" . buttonWidth . " h25", "Edit")
        this.AddButton("vRemoveButton xs+" . this.margin . " y+m w" . buttonWidth . " h25", "Remove")
        this.AddButton("vMoveUpButton xs+" . this.margin . " y+m w" . buttonWidth . " h25", "Up")
        this.AddButton("vMoveDownButton xs+" . this.margin . " y+m w" . buttonWidth . " h25", "Down")
        
        this.guiObj.AddGroupBox("vSortGroup xs y+" . this.margin*2 . " w" . this.sidebarWidth . " r2.5 Section", "Sort All")
        this.AddButton("vByNameButton xs+" . this.margin . " ys+" . gbY . " w" . buttonWidth . " h25", "By Name")
        this.AddButton("vByTypeButton xs+" . this.margin . " y+m w" . buttonWidth . " h25", "By Type")

        this.AddButton("vExitButton xs y+m w" . this.sidebarWidth . " h30", "E&xit")
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
