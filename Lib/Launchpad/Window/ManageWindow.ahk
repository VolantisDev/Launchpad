class ManageWindow extends LaunchpadGuiBase {
    sidebarWidth := 85
    listViewColumns := Array("Game", "Launcher Type", "Game Type", "Status")
    launcherManager := ""
    numSelected := 0

    __New(app, windowKey := "", owner := "", parent := "") {
        this.launcherManager := app.Launchers
        super.__New(app, "Launchpad", windowKey, owner, parent)
    }

    GetTitle(title) {
        return this.title
    }

    Controls() {
        super.Controls()
        this.AddLaunchersList()
        this.AddButton("vAddButton ys w" . this.sidebarWidth . " h30", "Add")
        this.AddButton("vEditButton xp y+m w" . this.sidebarWidth . " h30 Hidden", "Edit")
        this.AddButton("vBuildButton xp y+m w" . this.sidebarWidth . " h30 Hidden", "Build")
        this.AddButton("vRunButton xp y+m w" . this.sidebarWidth . " h30 Hidden", "Run")
        this.AddButton("vDeleteButton xp y+m w" . this.sidebarWidth . " h30 Hidden", "Delete")
        
        this.AddButton("vToolsButton xp y" . (this.titlebarHeight + this.windowSettings["listViewHeight"] - (this.margin * 5) - 100)  . " w" . this.sidebarWidth . " h30", "Tools")
        this.AddButton("vPlatformsButton xp y+m w" . this.sidebarWidth . " h30", "Platforms")
        this.AddButton("vSettingsButton xp y+m w" . this.sidebarWidth . " h30", "Settings")
        this.AddButton("vBuildAllButton xp y+m w" . this.sidebarWidth . " h40", "Build All", "", true)
    }

    Destroy() {
        currentApp := this.app
        super.Destroy()
        currentApp.ExitApp()
    }

    AddLaunchersList() {
        styling := "C" . this.themeObj.GetColor("text")
        lvStyles := "+LV" . LVS_EX_LABELTIP . " +LV" . LVS_EX_AUTOSIZECOLUMNS . " +LV" . LVS_EX_DOUBLEBUFFER . " +LV" . LVS_EX_FLATSB . " -E0x200"
        lvStyles .= " +LV" . LVS_EX_TRANSPARENTBKGND . " +LV" . LVS_EX_TRANSPARENTSHADOWTEXT
        listViewWidth := this.windowSettings["contentWidth"] - this.sidebarWidth - this.margin
        lv := this.guiObj.AddListView("vListView w" . listViewWidth . " h" . this.windowSettings["listViewHeight"] . " " . styling . " Count" . this.launcherManager.CountEntities() . " Section +Report -Multi " . lvStyles, this.listViewColumns)
        lv.OnEvent("DoubleClick", "OnDoubleClick")
        lv.OnEvent("ItemSelect", "OnItemSelect")
        this.PopulateListView()
    }

    PopulateListView() {
        this.guiObj["ListView"].Delete()
        iconNum := 1
        IL := this.CreateIconList()
        this.guiObj["ListView"].SetImageList(IL)

        for key, launcher in this.launcherManager.Entities {
            launcherStatus := "Missing"

            if (launcher.isBuilt) {
                launcherStatus := launcher.IsOutdated ? "Outdated" : "Present"
            }

            this.guiObj["ListView"].Add("Icon" . iconNum, launcher.Key, launcher.ManagedLauncher.EntityType, launcher.ManagedLauncher.ManagedGame.EntityType, launcherStatus)
            iconNum++
        }

        for index, col in this.listViewColumns {
            this.guiObj["ListView"].ModifyCol(index, "AutoHdr")
        }
    }

    CreateIconList() {
        IL := IL_Create(this.launcherManager.CountEntities(), 1, false)
        defaultIcon := A_ScriptDir . "\Resources\Graphics\Game.ico"
        
        iconNum := 1
        for key, launcher in this.launcherManager.Entities {
            iconSrc := launcher.iconSrc
            
            assetIcon := launcher.AssetsDir . "\" . key . ".ico"
            if ((!iconSrc || !FileExist(iconSrc)) && FileExist(assetIcon)) {
                iconSrc := assetIcon
            }

            if (!iconSrc) {
                iconSrc := defaultIcon
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
        launcherObj := this.launcherManager.Entities[key]
        diff := launcherObj.Edit("config", this.guiObj)
        keyChanged := (launcherObj.Key != key)

        if (keyChanged || diff != "" && diff.HasChanges()) {
            if (keyChanged) {
                this.launcherManager.RemoveEntity(key)
                this.launcherManager.AddEntity(launcherObj.Key, launcherObj)
            }

            this.launcherManager.SaveModifiedEntities()
            launcherObj.UpdateDataSourceDefaults()
            this.PopulateListView()
        }
    }

    AddLauncher() {
        entity := this.app.Windows.LauncherWizard(this.guiObj)

        if (entity != "") {
            this.launcherManager.AddEntity(entity.Key, entity)
            this.launcherManager.SaveModifiedEntities()
            this.PopulateListView()
        }
    }

    OnItemSelect(LV, rowNum, selected) {
        this.numSelected += (selected) ? 1 : -1
        buttonState := this.numSelected > 0 ? "-Hidden" : "+Hidden"
        runButtonState := this.ShouldShowRunButton() ? "-Hidden" : "+Hidden"
        this.guiObj["EditButton"].Opt(buttonState)
        this.guiObj["BuildButton"].Opt(buttonState)
        this.guiObj["RunButton"].Opt(runButtonState)
        this.guiObj["DeleteButton"].Opt(buttonState)
    }

    ShouldShowRunButton() {
        showButton := false
        selected := this.guiObj["ListView"].GetNext()

        if (selected > 0) {
            key := this.guiObj["ListView"].GetText(selected, 1)
            launcherObj := this.launcherManager.Entities[key]
            showButton := launcherObj.IsBuilt
        }

        return showButton
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

    OnBuildAllButton(btn, info) {
        this.app.Builders.BuildLaunchers(this.app.Launchers.Entities, this.app.Config.RebuildExistingLaunchers)
        this.PopulateListView()
    }

    OnSettingsButton(btn, info) {
        this.app.Windows.OpenSettingsWindow("ManageWindow")
    }

    OnPlatformsButton(btn, info) {
        this.app.Windows.OpenPlatformsWindow()
    }

    OnToolsButton(btn, info) {
        this.app.Windows.OpenToolsWindow("ManageWindow")
    }

    OnBuildButton(btn, info) {
        selected := this.guiObj["ListView"].GetNext()

        if (selected > 0) {
            key := this.guiObj["ListView"].GetText(selected, 1)
            launcherObj := this.launcherManager.Entities[key]
            this.app.Builders.BuildLaunchers(Map(key, launcherObj), true)
            this.PopulateListView()
        }
    }

    OnRunButton(btn, info) {
        selected := this.guiObj["ListView"].GetNext()

        if (selected > 0) {
            key := this.guiObj["ListView"].GetText(selected, 1)
            launcherObj := this.launcherManager.Entities[key]
            
            if (launcherObj.IsBuilt) {
                file := launcherObj.GetLauncherFile(key, false)

                if (file) {
                    Run(file,, "Hide")
                }
            }
        }
    }

    OnDeleteButton(btn, info) {
        selected := this.guiObj["ListView"].GetNext()

        if (selected > 0) {
            key := this.guiObj["ListView"].GetText(selected, 1)
            launcherObj := this.launcherManager.Entities[key]
            result := this.app.Windows.LauncherDeleteWindow(launcherObj, "ManageWindow")

            if (result == "Delete") {
                this.guiObj["ListView"].Delete(selected)
            }
        }
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
        this.AutoXYWH("x", ["AddButton", "EditButton", "BuildButton", "RunButton", "DeleteButton"])
        this.AutoXYWH("xy", ["BuildAllButton"])
        this.AutoXYWH("xy*", ["SettingsButton", "ToolsButton", "PlatformsButton"])

        if (this.hToolbar) {
            this.guiObj["Toolbar"].Move(,,width)
        }

        for index, col in this.listViewColumns {
            this.guiObj["ListView"].ModifyCol(index, "AutoHdr")
        }
    }
}
