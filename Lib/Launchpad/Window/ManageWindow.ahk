class ManageWindow extends LaunchpadGuiBase {
    sidebarWidth := 85
    listViewColumns := Array("Game", "Launcher Type", "Game Type")
    launcherFile := ""
    launcherManager := ""
    launchersModified := false
    numSelected := 0

    __New(app, launcherFile := "", windowKey := "", owner := "", parent := "") {
        if (launcherFile == "") {
            launcherFile := app.Config.LauncherFile
        }

        InvalidParameterException.CheckTypes("ManageWindow", "launcherFile", launcherFile, "")
        this.launcherFile := launcherFile
        this.launcherManager := LauncherManager.new(app, launcherFile)
        super.__New(app, "Manage", windowKey, owner, parent)
    }

    GetTitle(title) {
        return super.GetTitle(this.launcherFile . " - " . title)
    }

    Controls() {
        super.Controls()
        this.AddLaunchersList()
        this.AddButton("vAddButton ys w" . this.sidebarWidth . " h30", "Add")
        this.AddButton("vEditButton xp y+m w" . this.sidebarWidth . " h30 Hidden", "Edit")
        this.AddButton("vRemoveButton xp y+m w" . this.sidebarWidth . " h30 Hidden", "Remove")
        this.AddButton("vExitButton xp y" . this.windowSettings["listViewHeight"] - 30 + this.margin . " w" . this.sidebarWidth . " h30", "E&xit")
    }

    Destroy() {
        if (this.launchersModified) {
            shouldSave := MsgBox("Your launchers have been modified. Would you like to commit your changes back to " . this.launcherFile . "?", "Save modifications?", "YesNo")

            if (shouldSave == "Yes") {
                this.launcherManager.SaveModifiedLaunchers()
            }
        }

        super.Destroy()
    }

    AddLaunchersList() {
        styling := "C" . this.themeObj.GetColor("text")
        lvStyles := "+LV" . LVS_EX_LABELTIP . " +LV" . LVS_EX_AUTOSIZECOLUMNS . " +LV" . LVS_EX_DOUBLEBUFFER . " +LV" . LVS_EX_FLATSB
        lvStyles .= " +LV" . LVS_EX_TRANSPARENTBKGND . " +LV" . LVS_EX_TRANSPARENTSHADOWTEXT
        listViewWidth := this.windowSettings["contentWidth"] - this.sidebarWidth - this.margin
        lv := this.guiObj.AddListView("vListView w" . listViewWidth . " h" . this.windowSettings["listViewHeight"] . " " . styling . " Count" . this.launcherManager.CountLaunchers() . " Section +Report -Multi " . lvStyles, this.listViewColumns)
        lv.OnEvent("DoubleClick", "OnDoubleClick")
        lv.OnEvent("ItemSelect", "OnItemSelect")
        this.PopulateListView()
    }

    PopulateListView() {
        if (!this.launcherManager.launchersLoaded) {
            this.launcherManager.LoadLaunchers(this.launcherFile)
        }

        this.guiObj["ListView"].Delete()
        iconNum := 1
        IL := this.CreateIconList()
        this.guiObj["ListView"].SetImageList(IL)

        for key, launcher in this.launcherManager.Launchers {
            this.guiObj["ListView"].Add("Icon" . iconNum, launcher.Key, launcher.ManagedLauncher.EntityType, launcher.ManagedLauncher.ManagedGame.EntityType)
            iconNum++
        }

        this.guiObj["ListView"].ModifyCol()
    }

    CreateIconList() {
        IL := IL_Create(this.launcherManager.CountLaunchers(), 1, false)
        
        iconNum := 1
        for key, launcher in this.launcherManager.Launchers {
            iconSrc := launcher.iconSrc
            
            assetIcon := launcher.AssetsDir . "\" . key . ".ico"
            if ((!iconSrc || !FileExist(iconSrc)) && FileExist(assetIcon)) {
                iconSrc := assetIcon
            }

            IL_Add(IL, iconSrc)
            iconNum++
        }

        return IL
    }

    OnDoubleClick(LV, rowNum) {
        key := LV.GetText(rowNum)
        this.EditLauncher(key)
    }

    EditLauncher(key) {
        launcherObj := this.launcherManager.Launchers[key]
        modifiedValues := this.app.Windows.LauncherEditor(launcherObj, "config", this.guiObj)

        if (modifiedValues.Count > 0) {
            MsgBox modifiedValues.Count . " values modified"
            this.launchersModified := true

            if (launcherObj.Key != key) {
                this.launcherManager.RemoveLauncher(key)
                this.launcherManager.AddLauncher(key, launcherObj)
                launcherObj.MergeEntityDefaults(true)
            }

            this.PopulateListView()
        }
    }

    AddLauncher() {
        entityConfig := Map()
        entity := LauncherEntity.new(this.app, "new", entityConfig)
        modifiedValues := this.app.Windows.LauncherEditor(entity, "config", this.guiObj)
        
        if (modifiedValues.Count > 0 and entity.Key != "new") {
            this.launcherManager.AddLauncher(entity.Key, entity.UnmergedConfig)
            entity.MergeEntityDefaults()
            this.PopulateListView()
            this.launchersModified := true
        }
    }

    OnItemSelect(LV, rowNum, selected) {
        this.numSelected += (selected) ? 1 : -1
        buttonState := this.numSelected > 0 ? "-Hidden" : "+Hidden"
        this.guiObj["EditButton"].Opt(buttonState)
        this.guiObj["RemoveButton"].Opt(buttonState)
    }

    OnAddButton(btn, info) {
        this.AddLauncher()
    }

    OnEditButton(btn, info) {
        selected := this.guiObj["ListView"].GetNext()

        if (selected > 0) {
            key := this.guiObj["ListView"].GetText(selected, 1)
            this.EditLauncher(key)
        }
        
    }

    OnRemoveButton(btn, info) {
        selected := this.guiObj["ListView"].GetNext()

        if (selected > 0) {
            key := this.guiObj["ListView"].GetText(selected, 1)
            shouldRemove := MsgBox("This will delete the configuration for launcher " key . ". Are you sure?", "Delete " . key . "?", "YesNo")

            if (shouldRemove == "Yes") {
                this.launcherManager.RemoveLauncher(key)
                this.launchersModified := true
                this.guiObj["ListView"].Delete(selected)
            }
        }
    }

    OnExitButton(btn, info) {
        this.Destroy()
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
        this.AutoXYWH("x", ["AddButton", "EditButton", "RemoveButton"])
        this.AutoXYWH("xy", ["ExitButton"])

        if (this.hToolbar) {
            this.guiObj["Toolbar"].Move(,,width)
        }
    }
}
