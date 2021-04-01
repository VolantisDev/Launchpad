class ManageWindow extends ManageWindowBase {
    sidebarWidth := 0
    listViewColumns := Array("GAME", "PLATFORM", "STATUS", "API STATUS")
    launcherManager := ""
    platformManager := ""
    showStatusIndicator := true
    titleIsMenu := true
    launcherRows := []

    __New(app, themeObj, windowKey, owner := "", parent := "") {
        this.launcherManager := app.Launchers
        this.platformManager := app.Platforms
        this.lvCount := this.launcherManager.CountEntities()
        this.showStatusIndicator := app.Config.ApiAuthentication
        super.__New(app, themeObj, windowKey, app.appName, "", "")
    }

    GetTitle(title) {
        return this.title
    }

    AddBottomControls() {
        position := "x" . this.margin . " y+" . (this.margin)
        this.AddManageButton("AddButton", position, "add", true)
        position := "x+" . (this.margin) . " yp+5 w60 h25"
        this.AddButton("vEditButton " . position, "Edit", "", "manageText")
        position := "x+" . this.margin . " yp w60 h25"
        this.AddButton("vBuildButton " . position, "Build", "", "manageText")
        this.AddButton("vRunButton " . position, "Run", "", "manageText")
        this.AddButton("vDeleteButton " . position, "Delete", "", "manageText")

        actionButtonsW := 110
        actionButtonsX := (this.margin + this.windowSettings["contentWidth"] - actionButtonsW)
        position := "x" actionButtonsX . " yp-2 w" . actionButtonsW . " h30 Section"
        this.AddButton("vBuildAllButton " . position, "Build All", "", "primary")
    }

    ShowTitleMenu() {
        toolsItems := []
        toolsItems.Push(Map("label", "Manage &Platforms", "name", "ManagePlatforms"))
        toolsItems.Push(Map("label", "Manage &Backups", "name", "ManageBackups"))
        toolsItems.Push(Map("label", "&Clean Launchers", "name", "CleanLaunchers"))
        toolsItems.Push(Map("label", "&Reload Launchers", "name", "ReloadLaunchers"))

        menuItems := []
        menuItems.Push(Map("label", "&Tools", "name", "ToolsMenu", "childItems", toolsItems))
        menuItems.Push(Map("label", "&Settings", "name", "SettingsButton"))
        menuItems.Push(Map("label", "&Flush Cache", "name", "FlushCache"))
        menuItems.Push(Map("label", "Check for &Updates", "name", "CheckForUpdates"))
        menuItems.Push(Map("label", "Provide &Feedback", "name", "ProvideFeedback"))
        menuItems.Push(Map("label", "&Open Website", "name", "OpenWebsite"))
        menuItems.Push(Map("label", "&About Launchpad", "name", "About"))
        menuItems.Push(Map("label", "&Restart Launchpad", "name", "Reload"))
        menuItems.Push(Map("label", "E&xit Launchpad", "name", "Exit"))
        this.app.GuiManager.Menu("MenuGui", menuItems, this, this.windowKey, "", this.guiObj["WindowTitleText"])
    }

    OnManagePlatforms(btn, info) {
        this.app.GuiManager.OpenWindow("PlatformsWindow")
    }

    OnManageBackups(btn, info) {
        this.app.GuiManager.OpenWindow("ManageBackupsWindow")
    }

    OnCleanLaunchers(btn, info) {
        this.app.Builders.CleanLaunchers()
    }

    OnReloadLaunchers(btn, info) {
        this.app.Launchers.LoadComponents(this.app.Config.LauncherFile)

        if (this.app.GuiManager.WindowExists("ManageWindow")) {
            this.app.GuiManager.GetWindow("ManageWindow").PopulateListView()
        }
    }

    GetStatusInfo() {
        return this.app.Auth.GetStatusInfo()
    }

    OnFlushCache(btn, info) {
        this.app.Cache.FlushCaches()
    }

    OnOpenWebsite(btn, info) {
        this.app.OpenWebsite()
    }

    OnCheckForUpdates(btn, info) {
        this.app.CheckForUpdates()
    }

    OnAbout(btn, info) {
        this.app.GuiManager.Dialog("AboutWindow")
    }

    OnProvideFeedback(btn, info) {
        this.app.ProvideFeedback()
    }

    OnStatusIndicatorClick(btn, info) {
        menuItems := []

        if (this.app.Auth.IsAuthenticated()) {
            menuItems.Push(Map("label", "Account Details", "name", "AccountDetails"))
            menuItems.Push(Map("label", "Logout", "name", "Logout"))
        } else {
            menuItems.Push(Map("label", "Login", "name", "Login"))
        }

        this.app.GuiManager.Menu("MenuGui", menuItems, this, this.windowKey, "", btn)
    }

    OnAccountDetails(btn, info) {
        result := this.app.GuiManager.Dialog("AccountInfoWindow", this.windowKey)

        if (result == "OK") {
            this.UpdateStatusIndicator()
        }
    }

    StatusWindowIsOnline() {
        return this.app.Auth.IsAuthenticated()
    }

    SetupManageEvents(lv) {
        lv.OnEvent("DoubleClick", "OnDoubleClick")
    }

    PopulateListView(focusedItem := 1) {
        this.guiObj["ListView"].Delete()
        this.guiObj["ListView"].SetImageList(this.CreateIconList())
        iconNum := 1
        index := 1
        this.launcherRows := []

        for key, launcher in this.launcherManager.Entities {
            focusOption := index == focusedItem ? " Focus" : ""

            apiStatus := launcher.DataSourceItemKey ? "Linked" : "Not linked"

            platformName := launcher.Platform

            if (platformName) {
                platformObj := this.platformManager.GetItem(platformName)

                if (platformObj) {
                    platformName := platformObj.platform.displayName
                }
            }

            this.guiObj["ListView"].Add("Icon" . iconNum . focusOption, launcher.DisplayName, platformName, launcher.GetStatus(), apiStatus)
            this.launcherRows.Push(key)
            iconNum++
            index++
        }

        for index, col in this.listViewColumns {
            this.guiObj["ListView"].ModifyCol(index, "AutoHdr")
        }
    }

    CreateIconList() {
        IL := IL_Create(this.launcherManager.CountEntities(), 1, false)
        defaultIcon := this.themeObj.GetIconPath("Game")
        iconNum := 1

        for key, launcher in this.launcherManager.Entities {
            iconSrc := launcher.iconSrc
            
            assetIcon := launcher.AssetsDir . "\" . key . ".ico"
            if ((!iconSrc || !FileExist(iconSrc)) && FileExist(assetIcon)) {
                iconSrc := assetIcon
            }

            if (!iconSrc || !FileExist(iconSrc)) {
                iconSrc := defaultIcon
            }

            newIndex := IL_Add(IL, iconSrc)

            if (!newIndex) {
                IL_Add(IL, defaultIcon)
            }
            
            iconNum++
        }

        return IL
    }

    OnDoubleClick(LV, rowNum) {
        key := this.launcherRows[rowNum]
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

    ImportShortcut() {
        entity := this.app.GuiManager.Form("ImportShortcutForm", this.windowKey)

        if (entity) {
            this.launcherManager.AddEntity(entity.Key, entity)
            this.launcherManager.SaveModifiedEntities()
            this.PopulateListView()
        }
    }

    AddLauncher() {
        entity := this.app.GuiManager.Form("LauncherWizard", this.windowKey)

        if (entity) {
            this.launcherManager.AddEntity(entity.Key, entity)
            this.launcherManager.SaveModifiedEntities()
            this.PopulateListView()
        }
    }

    ShouldShowRunButton() {
        showButton := false
        selected := this.guiObj["ListView"].GetNext(, "Focused")

        if (selected > 0) {
            key := this.launcherRows[selected]
            launcherObj := this.launcherManager.Entities[key]
            showButton := launcherObj.IsBuilt
        }

        return showButton
    }

    OnAddButton(btn, info) {
        menuItems := []
        menuItems.Push(Map("label", "&Add Game", "name", "AddGame"))
        menuItems.Push(Map("label", "&Import Shortcut", "name", "ImportShortcut"))
        menuItems.Push(Map("label", "&Detect Games", "name", "DetectGames"))
        this.app.GuiManager.Menu("MenuGui", menuItems, this, this.windowKey, "", btn)
    }

    OnDetectGames(btn, info) {
        this.app.Platforms.DetectGames()
    }

    OnImportShortcut(btn, info) {
        if (this.app.GuiManager.WindowExists("ManageWindow")) {
            this.app.GuiManager.GetWindow("ManageWindow").ImportShortcut()
        }
    }

    OnAddGame(btn, info) {
        if (this.app.GuiManager.WindowExists("ManageWindow")) {
            this.app.GuiManager.GetWindow("ManageWindow").AddLauncher()
        }
    }

    OnEditButton(btn, info) {
        selected := this.guiObj["ListView"].GetNext(, "Focused")

        if (selected > 0) {
            key := this.launcherRows[selected]
            this.EditLauncher(key)
        }
        
    }

    OnBuildAllButton(btn, info) {
        this.app.Builders.BuildLaunchers(this.app.Launchers.Entities, this.app.Config.RebuildExistingLaunchers)
        this.PopulateListView()
    }

    OnSettingsButton(btn, info) {
        this.app.GuiManager.Form("SettingsWindow")
    }

    OnBuildButton(btn, info) {
        selected := this.guiObj["ListView"].GetNext(, "Focused")

        if (selected > 0) {
            key := this.launcherRows[selected]
            launcherObj := this.launcherManager.Entities[key]
            this.app.Builders.BuildLaunchers(Map(key, launcherObj), true)
            this.PopulateListView()
        }
    }

    OnRunButton(btn, info) {
        selected := this.guiObj["ListView"].GetNext(, "Focused")

        if (selected > 0) {
            key := this.launcherRows[selected]
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
        selected := this.guiObj["ListView"].GetNext(, "Focused")

        if (selected > 0) {
            key := this.launcherRows[selected]
            launcherObj := this.launcherManager.Entities[key]
            result := this.app.GuiManager.Dialog("LauncherDeleteWindow", launcherObj, this.app.Services.Get("LauncherManager"), this.windowKey)

            if (result == "Delete") {
                this.guiObj["ListView"].Delete(selected)
            }
        }
    }

    OnSize(guiObj, minMax, width, height) {
        super.OnSize(guiObj, minMax, width, height)
        
        if (minMax == -1) {
            return
        }

        this.AutoXYWH("y", ["AddButton", "EditButton", "BuildButton", "RunButton", "DeleteButton"])
        this.AutoXYWH("xy", ["BuildAllButton"])
    }

    Destroy() {
        currentApp := this.app
        super.Destroy()
        currentApp.ExitApp()
    }
}
