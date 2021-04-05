class MainWindow extends ManageWindowBase {
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
        actionButtonsW := 110
        actionButtonsX := (this.margin + this.windowSettings["contentWidth"] - actionButtonsW)
        position := "x" actionButtonsX . " yp+3 w" . actionButtonsW . " h30 Section"
        this.Add("ButtonControl", "vBuildAllButton " . position, "Build All", "", "primary")
    }

    ShowListViewContextMenu(lv, item, isRightClick, X, Y) {
        launcherKey := this.launcherRows[item]
        launcher := this.launcherManager.Entities[launcherKey]

        menuItems := []
        menuItems.Push(Map("label", "Edit", "name", "EditLauncher"))
        menuItems.Push(Map("label", "Build", "name", "BuildLauncher"))
        menuItems.Push(Map("label", "Run", "name", "RunLauncher"))
        menuItems.Push(Map("label", "Delete", "name", "DeleteLauncher"))

        result := this.app.GuiManager.Menu("MenuGui", menuItems, this)

        if (result == "EditLauncher") {
            this.EditLauncher(launcherKey)
        } else if (result == "BuildLauncher") {
            this.app.Builders.BuildLaunchers(Map(launcherKey, launcher), true)
            this.PopulateListView()
        } else if (result == "RunLauncher") {
            if (launcher.IsBuilt) {
                file := launcher.GetLauncherFile(launcherKey, false)

                if (file) {
                    Run(file,, "Hide")
                }
            }
        } else if (result == "DeleteLauncher") {
            result := this.app.GuiManager.Dialog("LauncherDeleteWindow", launcher, this.app.Services.Get("LauncherManager"), this.windowKey)

            if (result == "Delete") {
                this.guiObj["ListView"].Delete(item)
            }
        }
    }

    ShowTitleMenu() {
        toolsItems := []
        toolsItems.Push(Map("label", "Manage &Platforms", "name", "ManagePlatforms"))
        toolsItems.Push(Map("label", "Manage &Backups", "name", "ManageBackups"))
        toolsItems.Push(Map("label", "&Flush Cache", "name", "FlushCache"))

        launchersItems := []
        launchersItems.Push(Map("label", "&Clean Launchers", "name", "CleanLaunchers"))
        launchersItems.Push(Map("label", "&Reload Launchers", "name", "ReloadLaunchers"))

        aboutItems := []
        aboutItems.Push(Map("label", "&About Launchpad", "name", "About"))
        aboutItems.Push(Map("label", "&Open Website", "name", "OpenWebsite"))
        aboutItems.Push(Map("label", "Provide &Feedback", "name", "ProvideFeedback"))

        menuItems := []
        menuItems.Push(Map("label", "&Tools", "name", "ToolsMenu", "childItems", toolsItems))
        menuItems.Push(Map("label", "&Launchers", "name", "LaunchersMenu", "childItems", launchersItems))
        menuItems.Push("")
        menuItems.Push(Map("label", "&About", "name", "About", "childItems", aboutItems))
        menuItems.Push("")
        menuItems.Push(Map("label", "&Settings", "name", "Settings"))
        menuItems.Push(Map("label", "Check for &Updates", "name", "CheckForUpdates"))
        menuItems.Push("")
        menuItems.Push(Map("label", "&Restart", "name", "Reload"))
        menuItems.Push(Map("label", "E&xit", "name", "Exit"))
        
        
        result := this.app.GuiManager.Menu("MenuGui", menuItems, this, this.guiObj["WindowTitleText"])

        if (result == "ManagePlatforms") {
            this.app.GuiManager.OpenWindow("PlatformsWindow")
        } else if (result == "ManageBackups") {
            this.app.GuiManager.OpenWindow("ManageBackupsWindow")
        } else if (result == "FlushCache") {
            this.app.Cache.FlushCaches()
        } else if (result == "CleanLaunchers") {
            this.app.Builders.CleanLaunchers()
        } else if (result == "ReloadLaunchers") {
            this.app.Launchers.LoadComponents(this.app.Config.LauncherFile)
            this.PopulateListView()
        } else if (result == "About") {
            this.app.GuiManager.Dialog("AboutWindow")
        } else if (result == "OpenWebsite") {
            this.app.OpenWebsite()
        } else if (result == "ProvideFeedback") {
            this.app.ProvideFeedback()
        } else if (result == "Settings") {
            this.app.GuiManager.Form("SettingsWindow")
        } else if (result == "CheckForUpdates") {
            this.app.CheckForUpdates()
        } else if (result == "Reload") {
            Reload()
        } else if (result == "Exit") {
            this.app.ExitApp()
        }
    }

    GetStatusInfo() {
        return this.app.Auth.GetStatusInfo()
    }

    OnStatusIndicatorClick(btn, info) {
        menuItems := []

        if (this.app.Auth.IsAuthenticated()) {
            menuItems.Push(Map("label", "Account Details", "name", "AccountDetails"))
            menuItems.Push(Map("label", "Logout", "name", "Logout"))
        } else {
            menuItems.Push(Map("label", "Login", "name", "Login"))
        }

        result := this.app.GuiManager.Menu("MenuGui", menuItems, this, btn)

        if (result == "AccountDetails") {
            accountResult := this.app.GuiManager.Dialog("AccountInfoWindow", this.windowKey)

            if (accountResult == "OK") {
                this.UpdateStatusIndicator()
            }
        } else if (result == "Logout") {
            this.app.Auth.Logout()
        } else if (result == "Login") {
            this.app.Auth.Login()
        }
    }

    StatusWindowIsOnline() {
        return this.app.Auth.IsAuthenticated()
    }

    SetupManageEvents(lv) {
        super.SetupManageEvents(lv)
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
        entity := this.launcherManager.Entities[key]
        diff := entity.Edit("config", this.guiObj)
        keyChanged := (entity.Key != key)

        if (keyChanged || diff != "" && diff.HasChanges()) {
            if (keyChanged) {
                this.launcherManager.RemoveEntity(key)
                this.launcherManager.AddEntity(entity.Key, entity)
            }

            this.launcherManager.SaveModifiedEntities()
            entity.UpdateDataSourceDefaults()
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

        result := this.app.GuiManager.Menu("MenuGui", menuItems, this, btn)

        if (result == "AddGame") {
            this.AddLauncher()
        } else if (result == "ImportShortcut") {
            this.ImportShortcut()
        } else if (result == "DetectGames") {
            this.app.Platforms.DetectGames()
        }
    }

    OnBuildAllButton(btn, info) {
        this.app.Builders.BuildLaunchers(this.app.Launchers.Entities, this.app.Config.RebuildExistingLaunchers)
        this.PopulateListView()
    }

    OnSize(guiObj, minMax, width, height) {
        super.OnSize(guiObj, minMax, width, height)
        
        if (minMax == -1) {
            return
        }

        ;this.AutoXYWH("y", ["AddButton", "EditButton", "BuildButton", "RunButton", "DeleteButton"])
        this.AutoXYWH("y", ["AddButton"])
        this.AutoXYWH("xy", ["BuildAllButton"])
    }

    Destroy() {
        currentApp := this.app
        super.Destroy()
        currentApp.ExitApp()
    }
}
