class MainWindow extends ManageWindowBase {
    listViewColumns := Array("GAMES")
    launcherManager := ""
    platformManager := ""
    showStatusIndicator := true
    titleIsMenu := true
    showDetailsPane := true

    __New(app, themeObj, windowKey, owner := "", parent := "") {
        this.launcherManager := app.Service("LauncherManager")
        this.platformManager := app.Service("PlatformManager")
        this.lvCount := this.launcherManager.CountEntities()
        this.showStatusIndicator := app.Config.ApiAuthentication
        super.__New(app, themeObj, windowKey, app.appName, "", "")
    }

    GetTitle(title) {
        return this.title
    }

    AddBottomControls(y) {
        position := "x" . this.margin . " y" . y
        this.AddManageButton("AddButton", position, "add", true, "Add a Game")
        actionButtonsW := 110
        actionButtonsX := (this.margin + this.windowSettings["contentWidth"] - actionButtonsW)
        position := "x" actionButtonsX . " yp w" . actionButtonsW . " h30 Section"
        this.Add("ButtonControl", "vBuildAllButton " . position, "Build All", "", "primary")
    }

    ShowListViewContextMenu(lv, item, isRightClick, X, Y) {
        launcherKey := this.listView.GetRowKey(item)

        if (launcherKey) {
            launcher := this.launcherManager.Entities[launcherKey]

            menuItems := []
            menuItems.Push(Map("label", "Edit", "name", "EditLauncher"))
            menuItems.Push(Map("label", "Build", "name", "BuildLauncher"))
            menuItems.Push(Map("label", "Run", "name", "RunLauncher"))
            menuItems.Push(Map("label", "Delete", "name", "DeleteLauncher"))

            result := this.app.Service("GuiManager").Menu("MenuGui", menuItems, this)

            if (result == "EditLauncher") {
                this.EditLauncher(launcherKey)
            } else if (result == "BuildLauncher") {
                this.app.Service("BuilderManager").BuildLaunchers(Map(launcherKey, launcher), true)
                this.UpdateListView()
            } else if (result == "RunLauncher") {
                this.RunLauncher(launcherKey)
            } else if (result == "DeleteLauncher") {
                this.DeleteLauncher(launcherKey, item)
            }
        }
    }

    DeleteLauncher(launcherKey, rowNum := "") {
        launcher := this.launcherManager.Entities[launcherKey]
        result := this.app.Service("GuiManager").Dialog("LauncherDeleteWindow", launcher, this.app.Services.Get("LauncherManager"), this.windowKey)

        if (result == "Delete") {
            if (rowNum == "") {
                selected := this.listView.GetSelected()

                if (selected.Length > 0) {
                    rowNum := selected[1]
                }
            }

            this.guiObj["ListView"].Delete(rowNum)
        }
    }

    RunLauncher(launcherKey) {
        launcher := this.launcherManager.Entities[launcherKey]

        if (launcher && launcher.IsBuilt) {
            filePath := launcher.GetLauncherFile(launcherKey, false)

            if (filePath) {
                Run(filePath,, "Hide")
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
        
        result := this.app.Service("GuiManager").Menu("MenuGui", menuItems, this, this.guiObj["WindowTitleText"])

        if (result == "ManagePlatforms") {
            this.app.Service("GuiManager").OpenWindow("PlatformsWindow")
        } else if (result == "ManageBackups") {
            this.app.Service("GuiManager").OpenWindow("ManageBackupsWindow")
        } else if (result == "FlushCache") {
            this.app.Service("CacheManager").FlushCaches()
        } else if (result == "CleanLaunchers") {
            this.app.Service("BuilderManager").CleanLaunchers()
        } else if (result == "ReloadLaunchers") {
            this.app.Service("LauncherManager").LoadComponents(this.app.Config.LauncherFile)
            this.UpdateListView()
        } else if (result == "About") {
            this.app.Service("GuiManager").Dialog("AboutWindow")
        } else if (result == "OpenWebsite") {
            this.app.OpenWebsite()
        } else if (result == "ProvideFeedback") {
            this.app.ProvideFeedback()
        } else if (result == "Settings") {
            this.app.Service("GuiManager").Form("SettingsWindow")
        } else if (result == "CheckForUpdates") {
            this.app.CheckForUpdates()
        } else if (result == "Reload") {
            this.app.restartApp()
        } else if (result == "Exit") {
            this.app.ExitApp()
        }
    }

    GetStatusInfo() {
        return this.app.Service("Auth").GetStatusInfo()
    }

    OnStatusIndicatorClick(btn, info) {
        menuItems := []

        if (this.app.Service("Auth").IsAuthenticated()) {
            menuItems.Push(Map("label", "Account Details", "name", "AccountDetails"))
            menuItems.Push(Map("label", "Logout", "name", "Logout"))
        } else {
            menuItems.Push(Map("label", "Login", "name", "Login"))
        }

        result := this.app.Service("GuiManager").Menu("MenuGui", menuItems, this, btn)

        if (result == "AccountDetails") {
            accountResult := this.app.Service("GuiManager").Dialog("AccountInfoWindow", this.windowKey)

            if (accountResult == "OK") {
                this.UpdateStatusIndicator()
            }
        } else if (result == "Logout") {
            this.app.Service("Auth").Logout()
        } else if (result == "Login") {
            this.app.Service("Auth").Login()
        }
    }

    StatusWindowIsOnline() {
        return this.app.Service("Auth").IsAuthenticated()
    }

    FormatDate(timestamp) {
        shortDate := FormatTime(timestamp, "ShortDate")
        shortTime := FormatTime(timestamp, "Time")
        return shortDate . " " . shortTime
    }

    AddDetailsPane(y, key := "") {
        launcher := ""
        iconPath := ""
        displayName := ""
        platformIconPath := ""
        platformName := ""
        status := ""
        apiStatus := ""
        created := ""
        updated := ""
        built := ""

        if (key) {
            launcher := this.launcherManager.Entities[key]

            if (launcher) {
                iconPath := this.GetItemImage(launcher)
                displayName := launcher.DisplayName

                manager := this.app.Service("PlatformManager")

                if (launcher.Platform && manager.HasItem(launcher.Platform)) {
                    platform := manager.GetItem(launcher.Platform)
                    platformIconPath := this.GetPlatformImage(platform)
                    platformName := platform.GetDisplayName()
                }

                platformIconPath := 
                status := launcher.GetStatus()
                apiStatus := launcher.DataSourceItemKey ? "Linked" : "Not linked"
                created := this.FormatDate(this.app.State.GetLauncherCreated(key))
                updated := this.FormatDate(this.app.State.GetLauncherInfo("Config")["Timestamp"])
                built := this.FormatDate(this.app.State.GetLauncherInfo("Build")["Timestamp"])
            }
        }
        
        paneW := this.windowSettings["contentWidth"] - this.lvWidth - this.margin
        paneX := this.margin + this.lvWidth + (this.margin * 2)

        imgW := 24
        opts := "vDetailsPlatformIcon x" . paneX . " y" . y . " h" . imgW . " w" . imgW
        if (!key || !platformIconPath) {
            opts .= " Hidden"
        }
        this.guiObj.AddPicture(opts, platformIconPath)
        this.detailsFields.Push("DetailsPlatformIcon")

        textW := paneW - imgW - this.margin
        opts := "vDetailsPlatformName x+" . this.margin . " yp h" . imgW . " w" . textW
        if (!key || !platformName) {
            opts .= " Hidden"
        }
        this.AddText(platformName, opts)
        this.detailsFields.Push("DetailsPlatformName")

        imgW := 48
        opts := "vDetailsIcon x" . paneX . " y+" . (this.margin*2) . " h" . imgW . " w" . imgW
        if (!key) {
            opts .= " Hidden"
        }
        this.guiObj.AddPicture(opts, iconPath)
        this.detailsFields.Push("DetailsIcon")

        textW := paneW - imgW - this.margin
        opts := "vDetailsTitle x+" . this.margin . " yp h" . imgW . " w" . textW
        if (!key) {
            opts .= " Hidden"
        }
        this.AddText(displayName, opts, "large", "Bold")
        this.detailsFields.Push("DetailsTitle")

        opts := ["x" . paneX, "y+" . (this.margin*2), "vDetailsBuildButton", "h25", "w75"]
        if (!key) {
            opts.Push("Hidden")
        }
        this.Add("ButtonControl", opts, "Build", "OnDetailsBuildButton", "detailsButton")

        opts := ["x+" . this.margin, "yp", "h25", "vDetailsRunButton"]
        if (!key) {
            opts.Push("Hidden")
        }
        this.Add("ButtonControl", opts, "Run", "OnDetailsRunButton", "detailsButton")

        opts := ["x+" . this.margin, "yp", "h25", "vDetailsEditButton"]
        if (!key) {
            opts.Push("Hidden")
        }
        this.Add("ButtonControl", opts, "Edit", "OnDetailsEditButton", "detailsButton")

        opts := ["x+" . this.margin, "yp", "h25", "vDetailsDeleteButton"]
        if (!key) {
            opts.Push("Hidden")
        }
        this.Add("ButtonControl", opts, "Delete", "OnDetailsDeleteButton", "detailsButton")

        this.AddDetailsField("Key", "Key", key, "+" . (this.margin*2))
        this.AddDetailsField("Platform", "Platform", platformName, "", true, platformIconPath)
        this.AddDetailsField("Status", "Status", status)
        this.AddDetailsField("ApiStatus", "API Status", apiStatus)
        this.AddDetailsField("Created", "Created", created)
        this.AddDetailsField("Updated", "Updated", updated)
        this.AddDetailsField("Built", "Built", built)

        ; TODO: Add some entity details
    }

    AddDetailsField(fieldName, label, text, y := "", useIcon := false, icon := "") {
        if (!y) {
            y := "+" . (this.margin/2)
        }

        ctlH := 16
        imgW := useIcon ? ctlH : 0

        paneX := this.margin + this.lvWidth + (this.margin*2)
        paneW := this.windowSettings["contentWidth"] - this.lvWidth - this.margin
        opts := "vDetails" . fieldName . "Label x" . paneX . " y" . y . " h" . ctlH
        if (!text && !icon) {
            opts .= " Hidden"
        }
        ctl := this.AddText(label . ": ", opts, "normal", "Bold")
        ctl.GetPos(,, &w)

        textX := paneX + this.margin + w
        
        if (useIcon) {
            imgH := ctlH
            opts := "vDetails" . fieldName . "DetailIcon x" . textX . " yp h" . imgW . " w" . imgW
            if (!icon) {
                opts .= " Hidden"
            }
            this.guiObj.AddPicture(opts, icon)
            this.detailsFields.Push("Details" . fieldName . "DetailIcon")
        }
        
        fieldW := paneW - w - this.margin
        if (useIcon) {
            textX += (this.margin/2) + imgW
            fieldW -= ((this.margin/2) + imgW)
        }
        ; TODO: Set status text color based on status
        opts := "vDetails" . fieldName . "Text x" . textX . " yp w" . fieldW
        if (!text) {
            opts .= " Hidden"
        }
        this.AddText(text, opts)
        this.detailsFields.Push("Details" . fieldName . "Text")
    }

    OnDetailsRunButton(btn, info) {
        selected := this.listView.GetSelected("", true)

        if (selected.Length > 0) {
            this.RunLauncher(selected[1])
        }
    }

    OnDetailsBuildButton(btn, info) {
        selected := this.listView.GetSelected("", true)

        if (selected.Length > 0) {
            key := selected[1]
            launcher := this.launcherManager.Entities[key]
            this.app.Service("BuilderManager").BuildLaunchers(Map(key, launcher), true)
            this.UpdateListView()
        }
    }

    OnDetailsEditButton(btn, info) {
        selected := this.listView.GetSelected("", true)

        if (selected.Length > 0) {
            this.EditLauncher(selected[1])
        }
    }

    OnDetailsDeleteButton(btn, info) {
        selected := this.listView.GetSelected("", true)

        if (selected.Length > 0) {
            this.DeleteLauncher(selected[1])
        }
    }

    UpdateDetailsPane(key := "") {
        iconPath := ""
        displayName := ""
        platformIconPath := ""
        platformName := ""
        status := ""
        apiStatus := ""
        created := ""
        updated := ""
        built := ""

        if (key != "") {
            launcher := this.launcherManager.Entities[key]
            iconPath := this.GetItemImage(launcher)
            displayName := launcher.DisplayName

            manager := this.app.Service("PlatformManager")

            if (launcher.Platform && manager.HasItem(launcher.Platform)) {
                platform := manager.GetItem(launcher.Platform)
                platformIconPath := this.GetPlatformImage(platform)
                platformName := platform.GetDisplayName()
            }

            status := launcher.GetStatus()
            apiStatus := launcher.DataSourceItemKey ? "Linked" : "Not linked"
            created := this.FormatDate(this.app.State.GetLauncherCreated(key))
            updated := this.FormatDate(this.app.State.GetLauncherInfo(key, "Config")["Timestamp"])
            built := this.FormatDate(this.app.State.GetLauncherInfo(key, "Build")["Timestamp"])
        }
        
        this.guiObj["DetailsIcon"].Value := iconPath
        this.guiObj["DetailsIcon"].Move(,, 48, 48)
        this.guiObj["DetailsIcon"].Visible := (key != "")
        this.guiObj["DetailsTitle"].Text := displayName
        this.guiObj["DetailsTitle"].Visible := (key != "")
        this.guiObj["DetailsPlatformIcon"].Value := platformIconPath
        this.guiObj["DetailsPlatformIcon"].Move(,, 24, 24)
        this.guiObj["DetailsPlatformIcon"].Visible := (key != "" && platformIconPath != "")
        this.guiObj["DetailsPlatformName"].Text := platformName
        this.guiObj["DetailsPlatformName"].Visible := (key != "" && platformName != "")
        this.guiObj["DetailsRunButton"].Visible := (key != "")
        this.guiObj["DetailsBuildButton"].Visible := (key != "")
        this.guiObj["DetailsEditButton"].Visible := (key != "")
        this.guiObj["DetailsDeleteButton"].Visible := (key != "")
        this.guiObj["DetailsKeyText"].Visible := (key != "")
        this.guiObj["DetailsKeyText"].Text := key
        this.guiObj["DetailsKeyText"].Visible := (key != "")
        this.guiObj["DetailsKeyLabel"].Visible := (key != "")
        this.guiObj["DetailsPlatformText"].Visible := (key != "")
        this.guiObj["DetailsPlatformText"].Text := platformName
        this.guiObj["DetailsPlatformText"].Visible := (key != "")
        this.guiObj["DetailsPlatformDetailIcon"].Value := platformIconPath
        this.guiObj["DetailsPlatformDetailIcon"].Move(,, 16, 16)
        this.guiObj["DetailsPlatformDetailIcon"].Visible := (key != "" && platformIconPath != "")
        this.guiObj["DetailsPlatformLabel"].Visible := (key != "")
        this.guiObj["DetailsStatusLabel"].Visible := (key != "")
        this.guiObj["DetailsStatusText"].Text := status
        this.guiObj["DetailsStatusText"].Visible := (key != "")
        this.guiObj["DetailsApiStatusLabel"].Visible := (key != "")
        this.guiObj["DetailsApiStatusText"].Text := apiStatus
        this.guiObj["DetailsApiStatusText"].Visible := (key != "")
        this.guiObj["DetailsBuiltLabel"].Visible := (key != "")
        this.guiObj["DetailsBuiltText"].Text := built
        this.guiObj["DetailsBuiltText"].Visible := (key != "")
        this.guiObj["DetailsCreatedLabel"].Visible := (key != "")
        this.guiObj["DetailsCreatedText"].Text := created
        this.guiObj["DetailsCreatedText"].Visible := (key != "")
        this.guiObj["DetailsUpdatedLabel"].Visible := (key != "")
        this.guiObj["DetailsUpdatedText"].Text := updated
        this.guiObj["DetailsUpdatedText"].Visible := (key != "")
    }

    GetListViewData(lv) {
        data := Map()

        for key, launcher in this.launcherManager.Entities {
            apiStatus := launcher.DataSourceItemKey ? "Linked" : "Not linked"
            platformName := launcher.Platform

            if (platformName) {
                platformObj := this.platformManager.GetItem(platformName)

                if (platformObj) {
                    platformName := platformObj.platform.displayName
                }
            }

            ;data[key] := [launcher.DisplayName, platformName, launcher.GetStatus(), apiStatus]
            data[key] := [launcher.DisplayName]
        }

        return data
    }

    GetViewMode() {
        return "Report"
    }

    ShouldHighlightRow(key, data) {
        shouldHighlight := false

        if (key) {
            launcher := this.launcherManager.GetItem(key)
            shouldHighlight := launcher.GetStatus() != "Ready"
        }
        
        return shouldHighlight
    }

    GetListViewImgList(lv, large := false) {
        IL := IL_Create(this.launcherManager.CountEntities(), 1, large)
        defaultIcon := this.themeObj.GetIconPath("Game")
        iconNum := 1

        for key, launcher in this.launcherManager.Entities {
            iconSrc := this.GetItemImage(launcher)
            newIndex := IL_Add(IL, iconSrc)

            if (!newIndex) {
                IL_Add(IL, defaultIcon)
            }
            
            iconNum++
        }

        return IL
    }

    GetItemImage(launcher) {
        iconSrc := launcher.IconSrc
        assetIcon := launcher.AssetsDir . "\" . launcher.Key . ".ico"
        defaultIcon := this.themeObj.GetIconPath("Game")

        if ((!iconSrc || !FileExist(iconSrc)) && FileExist(assetIcon)) {
            iconSrc := assetIcon
        }

        if (!iconSrc || !FileExist(iconSrc)) {
            iconSrc := defaultIcon
        }

        return iconSrc
    }

    GetPlatformImage(platform) {
        iconSrc := platform.IconSrc
        ; TODO: Find a good default platform icon
        defaultIcon := ""

        if (!iconSrc || !FileExist(iconSrc)) {
            iconSrc := defaultIcon
        }

        return iconSrc
    }

    OnDoubleClick(LV, rowNum) {
        key := this.listView.GetRowKey(rowNum)

        if (this.app.Config.LauncherDoubleClickAction == "Run") {
            this.RunLauncher(key)
        } else {
            this.EditLauncher(key)
        }
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
            this.UpdateListView()
        }
    }

    ImportShortcut() {
        entity := this.app.Service("GuiManager").Form("ImportShortcutForm", this.windowKey)

        if (entity) {
            this.launcherManager.AddEntity(entity.Key, entity)
            this.launcherManager.SaveModifiedEntities()
            this.UpdateListView()
        }
    }

    AddLauncher() {
        entity := this.app.Service("GuiManager").Form("LauncherWizard", this.windowKey)

        if (entity) {
            this.launcherManager.AddEntity(entity.Key, entity)
            this.launcherManager.SaveModifiedEntities()
            this.UpdateListView()
        }
    }

    ShouldShowRunButton() {
        showButton := false
        selected := this.guiObj["ListView"].GetNext(, "Focused")

        if (selected > 0) {
            key := this.listView.GetRowKey(selected)
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

        result := this.app.Service("GuiManager").Menu("MenuGui", menuItems, this, btn)

        if (result == "AddGame") {
            this.AddLauncher()
        } else if (result == "ImportShortcut") {
            this.ImportShortcut()
        } else if (result == "DetectGames") {
            this.app.Service("PlatformManager").DetectGames()
        }
    }

    OnBuildAllButton(btn, info) {
        this.app.Service("BuilderManager").BuildLaunchers(this.app.Service("LauncherManager").Entities, this.app.Config.RebuildExistingLaunchers)
        this.UpdateListView()
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
