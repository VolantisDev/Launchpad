class LauncherManager extends GuiBase {
    windowOptions := "+Resize MinSize380x380"
    contentWidth := 510

    __New(app, owner := "", windowKey := "") {
        super.__New(app, app.AppConfig.LauncherFile, owner, windowKey)
    }

    Controls(posY) {
        posY := super.Controls(posY)
        sidebarWidth := 85
        lvWidth := this.contentWidth - sidebarWidth - this.margin
        lvHeight := 300
        lvPos := "x" . this.margin . " y" . posY . " w" . lvWidth . "h" . lvHeight

        lv := this.guiObj.AddListView("vListView " . lvPos . " +Report -Multi +LV0x4000 +NoSortHdr", ["Game", "Launcher Type"])

        sidebarX := lvWidth + (this.margin * 2)
        buttonX := sidebarX + 10
        buttonWidth := sidebarWidth - (this.margin * 2)

        this.guiObj.AddGroupBox("vLauncherGroup x" . sidebarX . " " . " y" . posY . "  w" . sidebarWidth . " h175", "Launcher")
        posY += 5 + this.margin
        this.guiObj.AddButton("vAddButton x" . buttonX . " y" . posY . " w" . buttonWidth . " h25", "Add")
        posY += 25 + this.margin
        this.guiObj.AddButton("vEditButton x" . buttonX . " y" . posY . " w" . buttonWidth . " h25", "Edit")
        posY += 25 + this.margin
        this.guiObj.AddButton("vRemoveButton x" . buttonX . " y" . posY . " w" . buttonWidth . " h25", "Remove")
        posY += 25 + (this.margin * 2)
        this.guiObj.AddButton("vMoveUpButton x" . buttonX . " y" . posY . " w" . buttonWidth . " h25", "Move Up")
        posY += 25 + this.margin
        this.guiObj.AddButton("vMoveDownButton x" . buttonX . " y" . posY . " w" . buttonWidth . " h25", "Move Down")
        posY += 25 + (this.margin * 2)
        
        this.guiObj.AddGroupBox("vSortGroup x" . sidebarX . " " . " y" . posY . "  w" . sidebarWidth . " h75", "Sort All")
        posY += 5 + this.margin
        this.guiObj.AddButton("vByNameButton x" . buttonX . " y" . posY . " w" . buttonWidth . " h25", "By Name")
        posY += 25 + this.margin
        this.guiObj.AddButton("vByTypeButton x" . buttonX . " y" . posY . " w" . buttonWidth . " h25", "By Type")
        posY += 25 + (this.margin * 2)

        this.guiObj.AddButton("vExitButton x" . sidebarX . " y" . posY . " w" . sidebarWidth . " h30", "E&xit")
        posY += 30 + this.margin

        return posY
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

        return this.CreateToolbar("OnLauncherManagerToolbar", ImageList, buttonList)
    }

    OnLauncherManagerToolbar(hWnd, Event, Text, Pos, Id) {
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
