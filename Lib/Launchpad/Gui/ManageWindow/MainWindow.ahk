class MainWindow extends ManageWindowBase {
    listViewColumns := Array("GAMES")
    launcherManager := ""
    platformManager := ""
    showDetailsPane := true

    __New(container, themeObj, config) {
        this.launcherManager := container.Get("entity_manager.launcher")
        this.platformManager := container.Get("entity_manager.platform")
        this.lvCount := this.launcherManager.Count(true)
        super.__New(container, themeObj, config)
    }

    GetDefaultConfig(container, config) {
        defaults := super.GetDefaultConfig(container, config)
        defaults["ownerOrParent"] := ""
        defaults["child"] := false
        defaults["title"] := container.GetApp().appName
        defaults["titleIsMenu"] := true
        defaults["showStatusIndicator"] := !!(container.Get("config.app").Has("api_authentication") && container.Get("config.app")["api_authentication"])
        return defaults
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
        launcherId := this.listView.GetRowKey(item)

        if (launcherId) {
            launcher := this.launcherManager[launcherId]

            menuItems := []
            menuItems.Push(Map("label", "Edit", "name", "EditLauncher"))
            menuItems.Push(Map("label", "Build", "name", "BuildLauncher"))
            menuItems.Push(Map("label", "Run", "name", "RunLauncher"))
            menuItems.Push(Map("label", "Delete", "name", "DeleteLauncher"))

            result := this.container["manager.gui"].Menu(menuItems, this)

            if (result == "EditLauncher") {
                this.EditLauncher(launcherId)
            } else if (result == "BuildLauncher") {
                this.container["manager.builder"].BuildLaunchers(Map(launcherId, launcher), true)
                this.UpdateListView()
            } else if (result == "RunLauncher") {
                this.RunLauncher(launcherId)
            } else if (result == "DeleteLauncher") {
                this.DeleteLauncher(launcherId, item)
            }
        }
    }

    DeleteLauncher(launcherId, rowNum := "") {
        launcher := this.launcherManager[launcherId]
        result := this.container["manager.gui"].Dialog(Map(
            "type", "LauncherDeleteWindow",
            "ownerOrParent", this.guiId,
            "child", true,
        ), launcher, this.launcherManager)

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

    RunLauncher(launcherId) {
        launcher := this.launcherManager[launcherId]

        if (launcher && launcher.IsBuilt) {
            filePath := launcher.GetLauncherFile(launcherId, false)

            if (filePath) {
                Run(filePath,, "Hide")
            }
        }
    }

    _getToolsMenuEntityTypes() {
        entityTypes := Map()

        for key, entityType in this.container["manager.entity_type"] {
            if (entityType.definition["manager_link_in_tools_menu"]) {
                entityTypes[key] := entityType
            }
        }

        return entityTypes
    }

    ShowTitleMenu() {
        menuEntityTypes := this._getToolsMenuEntityTypes()
        toolsItems := []

        for key, entityType in menuEntityTypes {
            menuLinkText := entityType.definition["manager_menu_link_text"]

            if (!menuLinkText) {
                menuLinkText := "&" . entityType.definition["name_plural"]
            }

            toolsItems.Push(Map("label", menuLinkText, "name", "manage_" . key))
        }

        toolsItems.Push(Map("label", "&Modules", "name", "ManageModules"))
        toolsItems.Push(Map("label", "&Flush Cache", "name", "FlushCache"))

        launchersItems := []
        launchersItems.Push(Map("label", "&Clean Launchers", "name", "CleanLaunchers"))
        launchersItems.Push(Map("label", "&Reload Launchers", "name", "ReloadLaunchers"))

        aboutItems := []
        aboutItems.Push(Map("label", "&About Launchpad", "name", "About"))
        aboutItems.Push(Map("label", "&Open Website", "name", "OpenWebsite"))

        menuItems := []
        menuItems.Push(Map("label", "&Tools", "name", "ToolsMenu", "childItems", toolsItems))
        menuItems.Push(Map("label", "&Launchers", "name", "LaunchersMenu", "childItems", launchersItems))
        menuItems.Push("")
        menuItems.Push(Map("label", "&About", "name", "About", "childItems", aboutItems))
        menuItems.Push("")
        menuItems.Push(Map("label", "&Settings", "name", "Settings"))
        menuItems.Push(Map("label", "Check for &Updates", "name", "CheckForUpdates"))
        menuItems.Push("")
        menuItems.Push(Map("label", "Provide &Feedback", "name", "ProvideFeedback"))
        menuItems.Push("")
        menuItems.Push(Map("label", "&Restart", "name", "Reload"))
        menuItems.Push(Map("label", "E&xit", "name", "Exit"))
        
        result := this.container["manager.gui"].Menu(menuItems, this, this.guiObj["WindowTitleText"])
        
        if (result == "ManageModules") {
            this.container["manager.gui"].OpenWindow("ManageModulesWindow")
        } else if (result == "FlushCache") {
            this.container["manager.cache"].FlushCaches(true, true)
        } else if (result == "CleanLaunchers") {
            this.container["manager.builder"].CleanLaunchers()
        } else if (result == "ReloadLaunchers") {
            this.launcherManager.LoadComponents(true)
            this.UpdateListView()
        } else if (result == "About") {
            this.container["manager.gui"].Dialog(Map("type", "AboutWindow"))
        } else if (result == "OpenWebsite") {
            this.app.OpenWebsite()
        } else if (result == "ProvideFeedback") {
            this.app.ProvideFeedback()
        } else if (result == "Settings") {
            this.container["manager.gui"].Dialog(Map("type", "SettingsWindow", "unique", false))
        } else if (result == "CheckForUpdates") {
            this.app.CheckForUpdates()
        } else if (result == "Reload") {
            this.app.restartApp()
        } else if (result == "Exit") {
            this.app.ExitApp()
        } else {
            for key, entityType in menuEntityTypes {
                if (result == "manage_" . key) {
                    this.container["entity_type." . key].OpenManageWindow()
                    break
                }
            }
        }
    }

    GetStatusInfo() {
        info := ""

        if (this.container.Has("Auth")) {
            info := this.container["Auth"].GetStatusInfo()
        }

        return info
    }

    OnStatusIndicatorClick(btn, info) {
        menuItems := []

        if (this.container.Has("Auth")) {
            if (this.container["Auth"].IsAuthenticated()) {
                menuItems.Push(Map("label", "Account Details", "name", "AccountDetails"))
                menuItems.Push(Map("label", "Logout", "name", "Logout"))
            } else {
                menuItems.Push(Map("label", "Login", "name", "Login"))
            }
        }

        result := this.container["manager.gui"].Menu(menuItems, this, btn)

        if (result == "AccountDetails") {
            accountResult := this.container["manager.gui"].Dialog(Map(
                "type", "AccountInfoWindow",
                "ownerOrParent", this.guiId,
                "child", true
            ))

            if (accountResult == "OK") {
                this.UpdateStatusIndicator()
            }
        } else if (result == "Logout") {
            if (this.container.Has("Auth")) {
                this.container["Auth"].Logout()
            }
        } else if (result == "Login") {
            if (this.container.Has("Auth")) {
                this.container["Auth"].Login()
            }
        }
    }

    StatusWindowIsOnline() {
        isOnline := false

        if (this.container.Has("Auth")) {
            isOnline := this.container["Auth"].IsAuthenticated()
        }
        return isOnline
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
            launcher := this.launcherManager[key]

            if (launcher) {
                iconPath := this.GetItemImage(launcher)
                displayName := launcher["name"]

                if (launcher.Has("Platform", false)) {
                    platform := launcher["Platform"]
                    platformIconPath := this.GetPlatformImage(platform)
                    platformName := platform.GetName()
                }

                status := launcher.GetStatus()
                apiStatus := launcher["DataSourceItemKey"] ? "Linked" : "Not linked"
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

        this.AddDetailsField("Id", "Id", key, "+" . (this.margin*2))
        this.AddDetailsField("Platform", "Platform", platformName, "", true, platformIconPath)
        this.AddDetailsField("Status", "Status", status)
        this.AddDetailsField("ApiStatus", "API Status", apiStatus)
        this.AddDetailsField("Created", "Created", created)
        this.AddDetailsField("Updated", "Updated", updated)
        this.AddDetailsField("Built", "Built", built)
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
            launcher := this.launcherManager[key]
            this.container["manager.builder"].BuildLaunchers(Map(key, launcher), true)
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
            launcher := this.launcherManager[key]
            iconPath := this.GetItemImage(launcher)
            displayName := launcher["name"]

            if (launcher.Has("Platform", false)) {
                platform := launcher["Platform"]
                platformIconPath := this.GetPlatformImage(platform)
                platformName := platform.GetName()
            }

            status := launcher.GetStatus()
            apiStatus := launcher["DataSourceItemKey"] ? "Linked" : "Not linked"
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
        this.guiObj["DetailsIdText"].Visible := (key != "")
        this.guiObj["DetailsIdText"].Text := key
        this.guiObj["DetailsIdText"].Visible := (key != "")
        this.guiObj["DetailsIdLabel"].Visible := (key != "")
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

        for key, launcher in this.launcherManager {
            data[key] := [launcher["name"]]
        }

        return data
    }

    GetViewMode() {
        return "Report"
    }

    ShouldHighlightRow(key, data) {
        shouldHighlight := false

        if (key) {
            launcher := this.launcherManager[key]
            shouldHighlight := launcher.GetStatus() != "Ready"
        }
        
        return shouldHighlight
    }

    GetListViewImgList(lv, large := false) {
        IL := IL_Create(this.launcherManager.Count(true), 1, large)
        defaultIcon := this.themeObj.GetIconPath("Game")
        iconNum := 1

        for key, launcher in this.launcherManager {
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
        iconSrc := launcher["IconSrc"]
        assetIcon := launcher["AssetsDir"] . "\" . launcher.Id . ".ico"
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
        iconSrc := platform["IconSrc"]
        ; TODO: Find a good default platform icon
        defaultIcon := ""

        if (!iconSrc || !FileExist(iconSrc)) {
            iconSrc := defaultIcon
        }

        return iconSrc
    }

    OnDoubleClick(LV, rowNum) {
        key := this.listView.GetRowKey(rowNum)

        if (this.app.Config["launcher_double_click_action"] == "Run") {
            this.RunLauncher(key)
        } else {
            this.EditLauncher(key)
        }
    }

    EditLauncher(key) {
        entity := this.launcherManager[key]
        formMode := this.app.Config["use_advanced_launcher_editor"] ? "config" : "simple"
        diff := entity.Edit(formMode, this.guiId)
        keyChanged := (entity.Id != key)

        if (keyChanged || diff != "" && diff.HasChanges()) {
            if (keyChanged) {
                this.launcherManager.RemoveEntity(key)
                this.launcherManager.AddEntity(entity.Id, entity)
            }

            entity.SaveEntity()
            entity.UpdateDataSourceDefaults()
            this.UpdateListView()
        }
    }

    ImportShortcut() {
        entity := this.container["manager.gui"].Dialog(Map("type", "ImportShortcutForm", "ownerOrParent", this.guiId))

        if (entity) {
            this.launcherManager.AddEntity(entity.Id, entity)
            entity.SaveEntity()
            this.UpdateListView()
        }
    }

    AddLauncher() {
        entity := this.container["manager.gui"].Dialog(Map("type", "LauncherWizard", "ownerOrParent", this.guiId))

        if (entity) {
            this.launcherManager.AddEntity(entity.Id, entity)
            entity.SaveEntity()
            this.UpdateListView()
        }
    }

    ShouldShowRunButton() {
        showButton := false
        selected := this.guiObj["ListView"].GetNext(, "Focused")

        if (selected > 0) {
            key := this.listView.GetRowKey(selected)
            launcherObj := this.launcherManager[key]
            showButton := launcherObj.IsBuilt
        }

        return showButton
    }

    OnAddButton(btn, info) {
        menuItems := []
        menuItems.Push(Map("label", "&Add Game", "name", "AddGame"))
        menuItems.Push(Map("label", "&Import Shortcut", "name", "ImportShortcut"))
        menuItems.Push(Map("label", "&Detect Games", "name", "DetectGames"))

        result := this.container["manager.gui"].Menu(menuItems, this, btn)

        if (result == "AddGame") {
            this.AddLauncher()
        } else if (result == "ImportShortcut") {
            this.ImportShortcut()
        } else if (result == "DetectGames") {
            this.platformManager.DetectGames()
        }
    }

    OnBuildAllButton(btn, info) {
        this.container["manager.builder"].BuildLaunchers(this.launcherManager.All("", false, true), this.app.Config["rebuild_existing_launchers"])
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
