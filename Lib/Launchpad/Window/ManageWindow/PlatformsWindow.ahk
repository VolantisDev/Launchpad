class PlatformsWindow extends ManageWindowBase {
    listViewColumns := Array("PLATFORM", "ENABLED", "DETECT GAMES", "INSTALLED", "VERSION")
    platformsFile := ""
    platformManager := ""
    platformRows := []
    sidebarWidth := 0

    __New(app, themeObj, windowKey, platformsFile := "", owner := "", parent := "") {
        if (platformsFile == "") {
            platformsFile := app.Config.PlatformsFile
        }

        InvalidParameterException.CheckTypes("PlatformsWindow", "platformsFile", platformsFile, "")
        this.platformsFile := platformsFile
        this.platformManager := app.Platforms
        this.lvCount := this.platformManager.CountEntities()
        super.__New(app, themeObj, windowKey, "Platforms", owner, parent)
    }

    AddBottomControls() {
        position := "x" . this.margin . " y+" . this.margin . " w60 h25"
        this.AddButton("vReloadButton ys " . position, "Reload", "", "manageText")
        position := "x+" . this.margin . " yp w60 h25"
        this.AddButton("vEnableButton " . position, "Enable", "", "manageText")
        this.AddButton("vDisableButton " . position, "Disable", "", "manageText")
        this.AddButton("vEditButton " . position, "Edit", "", "manageText")
        this.AddButton("vInstallButton " . position, "Install", "", "manageText")
        this.AddButton("vUpdateButton " . position, "Update", "", "manageText") ; @todo get this working again
        this.AddButton("vRunButton " . position, "Run", "", "manageText")
        this.AddButton("vUninstallButton " . position, "Uninstall", "", "manageText")
    }

    SetupManageEvents(lv) {
        lv.OnEvent("DoubleClick", "OnDoubleClick")
    }

    PopulateListView(focusedItem := 1) {
        this.guiObj["ListView"].Delete()
        this.guiObj["ListView"].SetImageList(this.CreateIconList())
        iconNum := 1
        index := 1
        this.platformRows := []

        for key, platform in this.platformManager.Entities {
            enabledText := platform.IsEnabled ? "Yes" : "No"
            detectGamesText := platform.DetectGames ? "Yes" : "No"
            installedText := platform.IsInstalled ? "Yes" : "No"
            focusOption := index == focusedItem ? " Focus" : ""
            this.guiObj["ListView"].Add("Icon" . iconNum . focusOption, platform.GetDisplayName(), enabledText, detectGamesText, installedText, platform.InstalledVersion)
            this.platformRows.Push(key)
            iconNum++
            index++
        }

        for index, col in this.listViewColumns {
            this.guiObj["ListView"].ModifyCol(index, "AutoHdr")
        }
    }

    CreateIconList() {
        IL := IL_Create(this.platformManager.CountEntities(), 1, false)
        defaultIcon := this.themeObj.GetIconPath("Platform")
        iconNum := 1

        for key, platform in this.platformManager.Entities {
            iconSrc := platform.IconSrc

            if (!iconSrc or !FileExist(iconSrc)) {
                iconSrc := defaultIcon
            }

            IL_Add(IL, iconSrc)
            iconNum++
        }

        return IL
    }

    OnDoubleClick(LV, rowNum) {
        key := this.platformRows[rowNum]
        this.EditPlatform(key)
    }

    EditPlatform(key) {
        platformObj := this.platformManager.Entities[key]
        diff := platformObj.Edit("config", this.guiObj)

        if (diff != "" && diff.HasChanges()) {
            this.platformManager.SaveModifiedEntities()
            this.PopulateListView()
        }
    }

    OnItemSelect(LV, rowNum, selected) {
        this.numSelected += (selected) ? 1 : -1
    }

    GetSelectedPlatform() {
        selected := this.guiObj["ListView"].GetNext()
        platform := ""

        if (selected > 0) {
            key := this.platformRows[selected]
            platform := this.platformManager.Entities[key]
        }

        return platform
    }

    OnEnableButton(btn, info) {
        platform := this.GetSelectedPlatform()
        selected := this.guiObj["ListView"].GetNext(, "Focused")

        if (platform) {
            platform.IsEnabled := true
            platform.SaveModifiedData()
            this.platformManager.SaveModifiedEntities()
            this.PopulateListView()

            if (selected) {
                this.guiObj["ListView"].Modify(selected, "Select")
            }
        }
    }

    OnDisableButton(btn, info) {
        platform := this.GetSelectedPlatform()
        selected := this.guiObj["ListView"].GetNext()

        if (platform) {
            platform.IsEnabled := false
            platform.SaveModifiedData()
            this.platformManager.SaveModifiedEntities()
            this.PopulateListView()

            if (selected) {
                this.guiObj["ListView"].Modify(selected, "Select")
            }
        }
    }

    OnReloadButton(btn, info) {
        this.platformManager.LoadComponents()
        this.PopulateListView()
    }

    OnEditButton(btn, info) {
        selected := this.guiObj["ListView"].GetNext(, "Focused")

        if (selected > 0) {
            key := this.platformRows[selected]
            this.EditPlatform(key)
        }
    }

    OnInstallButton(btn, info) {
        platform := this.GetSelectedPlatform()
        
        if (platform) {
            platform.Install()
        }
    }

    OnUninstallButton(btn, info) {
        platform := this.GetSelectedPlatform()

        if (platform && platform.IsInstalled) {
            platform.Uninstall()
        }
    }

    OnUpdateButton(btn, info) {
        platform := this.GetSelectedPlatform()

        if (platform) {
            platform.Update()
        }
    }

    OnRunButton(btn, info) {
        platform := this.GetSelectedPlatform()
        platform.Run()
    }

    OnSize(guiObj, minMax, width, height) {
        super.OnSize(guiObj, minMax, width, height)
        
        if (minMax == -1) {
            return
        }

        this.AutoXYWH("y", ["ReloadButton", "EnableButton", "DisableButton", "EditButton", "RunButton", "InstallButton", "UpdateButton", "UninstallButton"])
        
        for index, col in this.listViewColumns {
            this.guiObj["ListView"].ModifyCol(index, "AutoHdr")
        }
    }
}
