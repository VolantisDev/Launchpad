class PlatformsWindow extends LaunchpadGuiBase {
    sidebarWidth := 85
    listViewColumns := Array("Platform", "Enabled", "Installed", "Version")
    platformsFile := ""
    platformManager := ""
    platformsModified := false
    numSelected := 0

    __New(app, platformsFile := "", windowKey := "", owner := "", parent := "") {
        if (platformsFile == "") {
            platformsFile := app.Config.PlatformsFile
        }

        InvalidParameterException.CheckTypes("PlatformsWindow", "platformsFile", platformsFile, "")
        this.platformsFile := platformsFile
        this.platformManager := app.Platforms
        super.__New(app, "Platforms", windowKey, owner, parent)
    }

    Controls() {
        super.Controls()
        this.AddPlatformsList()
        this.AddButton("vReloadButton ys w" . this.sidebarWidth . " h30", "Reload")
        this.AddButton("vEnableButton xp y+m w" . this.sidebarWidth . " h30 Hidden", "Enable")
        this.AddButton("vDisableButton xp yp w" . this.sidebarWidth . " h30 Hidden", "Disable")
        this.AddButton("vEditButton xp y+m w" . this.sidebarWidth . " h30 Hidden", "Edit")
        this.AddButton("vInstallButton xp y+m w" . this.sidebarWidth . " h30 Hidden", "Install")
        this.AddButton("vUpdateButton xp yp w" . this.sidebarWidth . " h30 Hidden", "Update")
        this.AddButton("vRunButton xp y+m w" . this.sidebarWidth . " h30 Hidden", "Run")
    }

    Destroy() {
        if (this.platformsModified) {
            shouldSave := MsgBox("Your platforms have been modified. Would you like to commit your changes?", "Save modifications?", "YesNo")

            if (shouldSave == "Yes") {
                this.platformManager.SaveModifiedPlatforms()
            }
        }

        super.Destroy()
    }

    AddPlatformsList() {
        styling := "C" . this.themeObj.GetColor("text")
        lvStyles := "+LV" . LVS_EX_LABELTIP . " +LV" . LVS_EX_AUTOSIZECOLUMNS . " +LV" . LVS_EX_DOUBLEBUFFER . " +LV" . LVS_EX_FLATSB . " -E0x200"
        lvStyles .= " +LV" . LVS_EX_TRANSPARENTBKGND . " +LV" . LVS_EX_TRANSPARENTSHADOWTEXT
        listViewWidth := this.windowSettings["contentWidth"] - this.sidebarWidth - this.margin
        lv := this.guiObj.AddListView("vListView w" . listViewWidth . " h" . this.windowSettings["listViewHeight"] . " " . styling . " Count" . this.platformManager.CountPlatforms() . " Section +Report -Multi " . lvStyles, this.listViewColumns)
        lv.OnEvent("DoubleClick", "OnDoubleClick")
        lv.OnEvent("ItemSelect", "OnItemSelect")
        this.PopulateListView()
    }

    PopulateListView() {
        if (!this.platformManager._componentsLoaded) {
            this.platformManager.LoadComponents(this.platformsFile)
        }

        this.guiObj["ListView"].Delete()
        iconNum := 1
        this.guiObj["ListView"].SetImageList(this.CreateIconList())

        for key, platform in this.platformManager.Platforms {
            enabledText := platform.IsEnabled ? "Yes" : "No"
            installedText := platform.IsInstalled ? "Yes" : "No"
            this.guiObj["ListView"].Add("Icon" . iconNum, platform.Key, enabledText, installedText, platform.InstalledVersion)
            iconNum++
        }

        for index, col in this.listViewColumns {
            this.guiObj["ListView"].ModifyCol(index, "AutoHdr")
        }
    }

    CreateIconList() {
        IL := IL_Create(this.platformManager.CountPlatforms(), 1, false)
        defaultIcon := A_ScriptDir . "\Resources\Graphics\Platform.ico"
        
        iconNum := 1
        for key, platform in this.platformManager.Platforms {
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
        key := LV.GetText(rowNum)
        this.EditPlatform(key)
    }

    EditPlatform(key) {
        platformObj := this.platformManager.Platforms[key]
        diff := platformObj.Edit("config", this.guiObj)

        if (diff != "" && diff.HasChanges()) {
            this.platformsModified := true
            this.PopulateListView()
        }
    }

    OnItemSelect(LV, rowNum, selected) {
        this.numSelected += (selected) ? 1 : -1
        this.ResetButtonState()
    }

    ResetButtonState() {
        platform := this.GetSelectedPlatform()
        isInstalled := (platform && platform.IsInstalled)
        isEnabled := (platform && platform.IsEnabled)
        buttonState := platform ? "-Hidden" : "+Hidden"
        runButtonState := isInstalled ? "-Hidden" : "+Hidden"
        enableButtonState := (platform && !isEnabled) ? "-Hidden" : "+Hidden"
        disableButtonState := isEnabled ? "-Hidden" : "+Hidden"
        installButtonState := (platform && !isInstalled) ? "-Hidden" : "+Hidden"
        updateButtonState := isInstalled ? "-Hidden" : "+Hidden"
        
        this.guiObj["EditButton"].Opt(buttonState)
        this.guiObj["EnableButton"].Opt(enableButtonState)
        this.guiObj["DisableButton"].Opt(disableButtonState)
        this.guiObj["InstallButton"].Opt(installButtonState)
        this.guiObj["UpdateButton"].Opt(updateButtonState)
        this.guiObj["RunButton"].Opt(runButtonState)
    }

    GetSelectedPlatform() {
        selected := this.guiObj["ListView"].GetNext()
        platform := ""

        if (selected > 0) {
            key := this.guiObj["ListView"].GetText(selected, 1)
            platform := this.platformManager.Platforms[key]
        }

        return platform
    }

    OnEnableButton(btn, info) {
        platform := this.GetSelectedPlatform()
        selected := this.guiObj["ListView"].GetNext()

        if (platform) {
            platform.IsEnabled := true
            platform.SaveModifiedData()
            this.PopulateListView()
            this.platformsModified := true

            if (selected) {
                this.guiObj["ListView"].Modify(selected, "Select")
            }

            this.ResetButtonState()
        }
    }

    OnDisableButton(btn, info) {
        platform := this.GetSelectedPlatform()
        selected := this.guiObj["ListView"].GetNext()

        if (platform) {
            platform.IsEnabled := false
            platform.SaveModifiedData()
            this.PopulateListView()
            this.platformsModified := true

            if (selected) {
                this.guiObj["ListView"].Modify(selected, "Select")
            }

            this.ResetButtonState()
        }
    }

    OnReloadButton(btn, info) {
        this.platformManager.LoadComponents()
        this.PopulateListView()
    }

    OnEditButton(btn, info) {
        selected := this.guiObj["ListView"].GetNext()

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
        if (minMax == -1) {
            return
        }

        this.AutoXYWH("wh", ["ListView"])
        this.AutoXYWH("x", ["ReloadButton", "EnableButton", "DisableButton", "EditButton", "RunButton", "InstallButton", "UpdateButton"])
        
        for index, col in this.listViewColumns {
            this.guiObj["ListView"].ModifyCol()
        }
    }
}
