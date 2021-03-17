class ManageWindow extends ManageWindowBase {
    listViewColumns := Array("GAME", "PLATFORM", "STATUS", "API STATUS")
    launcherManager := ""
    platformManager := ""
    showStatusIndicator := true

    __New(app, windowKey := "", owner := "", parent := "") {
        this.launcherManager := app.Launchers
        this.platformManager := app.Platforms
        this.lvCount := this.launcherManager.CountEntities()
        super.__New(app, "Launchpad", windowKey, owner, parent)
    }

    GetTitle(title) {
        return this.title
    }

    AddSidebarControls() {
        this.AddButton("vAddButton ys w" . this.sidebarWidth . " h30", "Add")
        this.AddButton("vEditButton xp y+m w" . this.sidebarWidth . " h30", "Edit")
        this.AddButton("vBuildButton xp y+m w" . this.sidebarWidth . " h30", "Build")
        this.AddButton("vRunButton xp y+m w" . this.sidebarWidth . " h30", "Run")
        this.AddButton("vDeleteButton xp y+m w" . this.sidebarWidth . " h30", "Delete")
        
        this.AddButton("vToolsButton xp y" . (this.titlebarHeight + this.windowSettings["listViewHeight"] - (this.margin * 5) - 100)  . " w" . this.sidebarWidth . " h30", "Tools")
        this.AddButton("vPlatformsButton xp y+m w" . this.sidebarWidth . " h30", "Platforms")
        this.AddButton("vSettingsButton xp y+m w" . this.sidebarWidth . " h30", "Settings")
        this.AddButton("vBuildAllButton xp y+m w" . this.sidebarWidth . " h40", "Build All", "", true)
    }

    GetStatusText() {
        apiStatus := this.GetApiStatus()

        if (!apiStatus) {
            statusText := "Disconnected"
        } else if (apiStatus["authenticated"]) {
            statusText := apiStatus["email"]
        } else {
            statusText := "Not logged in"
        }

        return statusText
    }

    GetApiStatus() {
        dataSource := this.app.DataSources.GetItem("api")
        return dataSource.GetStatus()
    }

    OnStatusIndicatorClick(btn, info) {
        ; @todo Open a mini API configuration screen
    }

    SetupManageEvents(lv) {
        lv.OnEvent("DoubleClick", "OnDoubleClick")
    }

    PopulateListView(focusedItem := 1) {
        this.guiObj["ListView"].Delete()
        this.guiObj["ListView"].SetImageList(this.CreateIconList())
        iconNum := 1
        index := 1

        for key, launcher in this.launcherManager.Entities {
            launcherStatus := "Missing"

            if (launcher.IsBuilt) {
                launcherStatus := launcher.IsOutdated ? "Outdated" : "Present"
            }

            focusOption := index == focusedItem ? " Focus" : ""

            apiStatus := launcher.DataSourceItemKey ? "Merged" : "Not found"

            platformName := launcher.Platform

            if (platformName) {
                platformObj := this.platformManager.GetItem(platformName)

                if (platformObj) {
                    platformName := platformObj.platform.displayName
                }
            }

            this.guiObj["ListView"].Add("Icon" . iconNum . focusOption, launcher.Key, platformName, launcherStatus, apiStatus)
            iconNum++
            index++
        }

        for index, col in this.listViewColumns {
            this.guiObj["ListView"].ModifyCol(index, "AutoHdr")
        }
    }

    CreateIconList() {
        IL := IL_Create(this.launcherManager.CountEntities(), 1, false)
        defaultIcon := A_ScriptDir . "\Resources\Graphics\Game.ico"
        
        iconNum := 1
        for key, launcher in this.launcherManager.Entities {
            iconSrc := launcher.iconSrc
            
            assetIcon := launcher.AssetsDir . "\" . key . ".ico"
            if ((!iconSrc || !FileExist(iconSrc)) && FileExist(assetIcon)) {
                iconSrc := assetIcon
            }

            if (!iconSrc) {
                iconSrc := defaultIcon
            }

            IL_Add(IL, iconSrc)
            iconNum++
        }

        return IL
    }

    OnDoubleClick(LV, rowNum) {
        key := LV.GetText(rowNum)
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

    AddLauncher() {
        entity := this.app.Windows.LauncherWizard(this.guiObj)

        if (entity != "") {
            this.launcherManager.AddEntity(entity.Key, entity)
            this.launcherManager.SaveModifiedEntities()
            this.PopulateListView()
        }
    }

    ShouldShowRunButton() {
        showButton := false
        selected := this.guiObj["ListView"].GetNext(, "Focused")

        if (selected > 0) {
            key := this.guiObj["ListView"].GetText(selected, 1)
            launcherObj := this.launcherManager.Entities[key]
            showButton := launcherObj.IsBuilt
        }

        return showButton
    }

    OnAddButton(btn, info) {
        this.AddLauncher()
    }

    OnEditButton(btn, info) {
        selected := this.guiObj["ListView"].GetNext(, "Focused")

        if (selected > 0) {
            key := this.guiObj["ListView"].GetText(selected, 1)
            this.EditLauncher(key)
        }
        
    }

    OnBuildAllButton(btn, info) {
        this.app.Builders.BuildLaunchers(this.app.Launchers.Entities, this.app.Config.RebuildExistingLaunchers)
        this.PopulateListView()
    }

    OnSettingsButton(btn, info) {
        this.app.Windows.OpenSettingsWindow("ManageWindow")
    }

    OnPlatformsButton(btn, info) {
        this.app.Windows.OpenPlatformsWindow()
    }

    OnToolsButton(btn, info) {
        this.app.Windows.OpenToolsWindow("ManageWindow")
    }

    OnBuildButton(btn, info) {
        selected := this.guiObj["ListView"].GetNext(, "Focused")

        if (selected > 0) {
            key := this.guiObj["ListView"].GetText(selected, 1)
            launcherObj := this.launcherManager.Entities[key]
            this.app.Builders.BuildLaunchers(Map(key, launcherObj), true)
            this.PopulateListView()
        }
    }

    OnRunButton(btn, info) {
        selected := this.guiObj["ListView"].GetNext(, "Focused")

        if (selected > 0) {
            key := this.guiObj["ListView"].GetText(selected, 1)
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
            key := this.guiObj["ListView"].GetText(selected, 1)
            launcherObj := this.launcherManager.Entities[key]
            result := this.app.Windows.LauncherDeleteWindow(launcherObj, "ManageWindow")

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

        this.AutoXYWH("x", ["AddButton", "EditButton", "BuildButton", "RunButton", "DeleteButton"])
        this.AutoXYWH("xy", ["BuildAllButton"])
        this.AutoXYWH("xy*", ["SettingsButton", "ToolsButton", "PlatformsButton"])
    }

    Destroy() {
        currentApp := this.app
        super.Destroy()
        currentApp.ExitApp()
    }
}
