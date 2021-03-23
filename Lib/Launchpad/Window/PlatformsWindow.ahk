class PlatformsWindow extends ManageWindowBase {
    listViewColumns := Array("PLATFORM", "ENABLED", "DETECT GAMES", "INSTALLED", "VERSION")
    platformsFile := ""
    platformManager := ""
    platformRows := []

    __New(app, platformsFile := "", windowKey := "", owner := "", parent := "") {
        if (platformsFile == "") {
            platformsFile := app.Config.PlatformsFile
        }

        InvalidParameterException.CheckTypes("PlatformsWindow", "platformsFile", platformsFile, "")
        this.platformsFile := platformsFile
        this.platformManager := app.Platforms
        this.lvCount := this.platformManager.CountEntities()
        super.__New(app, "Platforms", windowKey, owner, parent)
    }

    AddSidebarControls() {
        this.AddButton("vReloadButton ys w" . this.sidebarWidth . " h30", "Reload")
        this.AddButton("vEnableButton xp y+m w" . this.sidebarWidth . " h30", "Enable")
        this.AddButton("vDisableButton xp y+m w" . this.sidebarWidth . " h30", "Disable")
        this.AddButton("vEditButton xp y+m w" . this.sidebarWidth . " h30", "Edit")
        this.AddButton("vInstallButton xp y+m w" . this.sidebarWidth . " h30", "Install")
        this.AddButton("vUpdateButton xp yp w" . this.sidebarWidth . " h30", "Update") ; @todo get this working again
        this.AddButton("vRunButton xp y+m w" . this.sidebarWidth . " h30", "Run")
        this.AddButton("vUninstallButton xp y+m w" . this.sidebarWidth . " h30", "Uninstall")
        
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
        defaultIcon := A_ScriptDir . "\Resources\Graphics\Platform.ico"
        
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
            key := this.guiObj["ListView"].GetText(selected, 1)
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

        this.AutoXYWH("x", ["ReloadButton", "EnableButton", "DisableButton", "EditButton", "RunButton", "InstallButton", "UpdateButton", "UninstallButton"])
        
        for index, col in this.listViewColumns {
            this.guiObj["ListView"].ModifyCol(index, "AutoHdr")
        }
    }
}
