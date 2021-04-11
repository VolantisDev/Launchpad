class PlatformsWindow extends ManageWindowBase {
    listViewColumns := Array("PLATFORM", "ENABLED", "DETECT GAMES", "INSTALLED", "VERSION")
    platformsFile := ""
    platformManager := ""

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

    GetViewMode() {
        return this.app.Config.PlatformsViewMode
    }

    GetListViewImgList(lv, large := false) {
        IL := IL_Create(this.platformManager.CountEntities(), 1, large)
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
        this.EditPlatform(this.listView.GetRowKey(rowNum))
    }

    EditPlatform(key) {
        platformObj := this.platformManager.Entities[key]
        diff := platformObj.Edit("config", this.guiObj)

        if (diff != "" && diff.HasChanges()) {
            this.platformManager.SaveModifiedEntities()
            this.UpdateListView()
        }
    }

    OnReloadButton(btn, info) {
        this.platformManager.LoadComponents()
        this.UpdateListView()
    }

    OnSize(guiObj, minMax, width, height) {
        super.OnSize(guiObj, minMax, width, height)
        
        if (minMax == -1) {
            return
        }

        this.AutoXYWH("y", ["ReloadButton"])
    }

    ShowListViewContextMenu(lv, item, isRightClick, X, Y) {
        key := this.listView.GetRowKey(item)
        platform := this.platformManager.Entities[key]

        menuItems := []
        menuItems.Push(Map("label", "Edit", "name", "EditPlatform"))

        if (platform.IsEnabled) {
            menuItems.Push(Map("label", "Disable", "name", "DisablePlatform"))
        } else {
            menuItems.Push(Map("label", "Enable", "name", "EnablePlatform"))
        }

        if (platform.IsInstalled) {
            menuItems.Push(Map("label", "Run", "name", "RunPlatform"))
            menuItems.Push(Map("label", "Update", "name", "UpdatePlatform"))
            menuItems.Push(Map("label", "Uninstall", "name", "UninstallPlatform"))
        } else {
            menuItems.Push(Map("label", "Install", "name", "InstallPlatform"))
        }

        result := this.app.GuiManager.Menu("MenuGui", menuItems, this)

        if (result == "EditPlatform") {
            this.EditPlatform(key)
        } else if (result == "DisablePlatform") {
            platform.IsEnabled := false
            platform.SaveModifiedData()
            this.platformManager.SaveModifiedEntities()
            this.UpdateListView()
        } else if (result == "EnablePlatform") {
            platform.IsEnabled := true
            platform.SaveModifiedData()
            this.platformManager.SaveModifiedEntities()
            this.UpdateListView()
        } else if (result == "RunPlatform") {
            platform.Run()
        } else if (result == "UpdatePlatform") {
            platform.Update()
        } else if (result == "UninstallPlatform") {
            platform.Uninstall()
        } else if (result == "InstallPlatform") {
            platform.Install()
        }
    }
}
