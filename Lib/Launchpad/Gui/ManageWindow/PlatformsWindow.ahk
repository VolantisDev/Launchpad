class PlatformsWindow extends ManageWindowBase {
    listViewColumns := Array("PLATFORM", "ENABLED", "DETECT GAMES", "INSTALLED", "VERSION")
    platformManager := ""

    __New(container, themeObj, config) {
        this.platformManager := container.Get("entity_manager.platform")
        this.lvCount := this.platformManager.Count(true)
        super.__New(container, themeObj, config)
    }

    GetDefaultConfig(container, config) {
        defaults := super.GetDefaultConfig(container, config)
        defaults["title"] := "Platforms"
        defaults["platformsFile"] := container.Get("config.app")["platforms_file"]
        return defaults
    }

    AddBottomControls(y) {
        position := "x" . this.margin . " y" . y . " w60 h25"
        this.Add("ButtonControl", "vReloadButton ys " . position, "Reload", "", "manageText")
    }

    GetListViewData(lv) {
        data := Map()

        for key, platform in this.platformManager {
            enabledText := platform["IsEnabled"] ? "Yes" : "No"
            detectGamesText := platform["DetectGames"] ? "Yes" : "No"
            installedText := platform["IsInstalled"] ? "Yes" : "No"
            data[key] := [platform.GetName(), enabledText, detectGamesText, installedText, platform["InstalledVersion"]]
        }

        return data
    }

    ShouldHighlightRow(key, data) {
        return false
    }

    GetViewMode() {
        return this.app.Config["platforms_view_mode"]
    }

    GetListViewImgList(lv, large := false) {
        IL := IL_Create(this.platformManager.Count(true), 1, large)
        defaultIcon := this.themeObj.GetIconPath("Platform")
        iconNum := 1

        for key, platform in this.platformManager {
            iconSrc := platform["IconSrc"]

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
        platformObj := this.platformManager[key]
        diff := platformObj.Edit("config", this.guiId)

        if (diff != "" && diff.HasChanges()) {
            platformObj.SaveEntity()
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
        platform := this.platformManager[key]

        menuItems := []
        menuItems.Push(Map("label", "Edit", "name", "EditPlatform"))

        if (platform["IsEnabled"]) {
            menuItems.Push(Map("label", "Disable", "name", "DisablePlatform"))
        } else {
            menuItems.Push(Map("label", "Enable", "name", "EnablePlatform"))
        }

        if (platform["IsInstalled"]) {
            menuItems.Push(Map("label", "Run", "name", "RunPlatform"))
            menuItems.Push(Map("label", "Update", "name", "UpdatePlatform"))
            menuItems.Push(Map("label", "Uninstall", "name", "UninstallPlatform"))
        } else {
            menuItems.Push(Map("label", "Install", "name", "InstallPlatform"))
        }

        result := this.app.Service("manager.gui").Menu(menuItems, this)

        if (result == "EditPlatform") {
            this.EditPlatform(key)
        } else if (result == "DisablePlatform") {
            platform["IsEnabled"] := false
            platform.SaveEntity()
            this.UpdateListView()
        } else if (result == "EnablePlatform") {
            platform["IsEnabled"] := true
            platform.SaveEntity()
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
