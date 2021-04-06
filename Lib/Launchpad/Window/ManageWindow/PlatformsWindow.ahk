class PlatformsWindow extends ManageWindowBase {
    listViewColumns := Array("PLATFORM", "ENABLED", "DETECT GAMES", "INSTALLED", "VERSION")
    platformsFile := ""
    platformManager := ""
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
        this.Add("ButtonControl", "vReloadButton ys " . position, "Reload", "", "manageText")
        position := "x+" . this.margin . " yp w60 h25"
        this.Add("ButtonControl", "vEnableButton " . position, "Enable", "", "manageText")
        this.Add("ButtonControl", "vDisableButton " . position, "Disable", "", "manageText")
        this.Add("ButtonControl", "vEditButton " . position, "Edit", "", "manageText")
        this.Add("ButtonControl", "vInstallButton " . position, "Install", "", "manageText")
        this.Add("ButtonControl", "vUpdateButton " . position, "Update", "", "manageText") ; @todo get this working again
        this.Add("ButtonControl", "vRunButton " . position, "Run", "", "manageText")
        this.Add("ButtonControl", "vUninstallButton " . position, "Uninstall", "", "manageText")
    }

    GetListViewData(lv) {
        data := Map()

        for key, platform in this.platformManager.Entities {
            enabledText := platform.IsEnabled ? "Yes" : "No"
            detectGamesText := platform.DetectGames ? "Yes" : "No"
            installedText := platform.IsInstalled ? "Yes" : "No"
            data[key] := [platform.GetDisplayName(), enabledText, detectGamesText, installedText, platform.InstalledVersion]
        }

        return data
    }

    GetListViewImgList(lv) {
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
        key := this.listView.GetRowKey(rowNum)
        this.EditPlatform(key)
    }

    EditPlatform(key) {
        platformObj := this.platformManager.Entities[key]
        diff := platformObj.Edit("config", this.guiObj)

        if (diff != "" && diff.HasChanges()) {
            this.platformManager.SaveModifiedEntities()
            this.UpdateListView()
        }
    }

    OnItemSelect(LV, rowNum, selected) {
        this.numSelected += (selected) ? 1 : -1
    }

    GetSelectedPlatform() {
        selected := this.guiObj["ListView"].GetNext()
        platform := ""

        if (selected > 0) {
            key := this.listView.GetRowKey(selected)
            platform := this.platformManager.Entities[key]
        }

        return platform
    }

    OnEnableButton(btn, info) {
        platform := this.GetSelectedPlatform()

        if (platform) {
            platform.IsEnabled := true
            platform.SaveModifiedData()
            this.platformManager.SaveModifiedEntities()
            this.UpdateListView()
        }
    }

    OnDisableButton(btn, info) {
        platform := this.GetSelectedPlatform()

        if (platform) {
            platform.IsEnabled := false
            platform.SaveModifiedData()
            this.platformManager.SaveModifiedEntities()
            this.UpdateListView()
        }
    }

    OnReloadButton(btn, info) {
        this.platformManager.LoadComponents()
        this.UpdateListView()
    }

    OnEditButton(btn, info) {
        selected := this.guiObj["ListView"].GetNext(, "Focused")

        if (selected > 0) {
            key := this.listView.GetRowKey(selected)
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
    }
}
