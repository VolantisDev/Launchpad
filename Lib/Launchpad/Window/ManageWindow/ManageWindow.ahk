class ManageWindow extends ManageWindowBase {
    sidebarWidth := 0
    listViewColumns := Array("GAME", "PLATFORM", "STATUS", "API STATUS")
    launcherManager := ""
    platformManager := ""
    showStatusIndicator := true

    __New(app, themeObj, windowKey, owner := "", parent := "") {
        this.launcherManager := app.Launchers
        this.platformManager := app.Platforms
        this.lvCount := this.launcherManager.CountEntities()
        this.showStatusIndicator := app.Config.ApiAuthentication
        super.__New(app, themeObj, windowKey, "Launchpad", "", "")
    }

    GetTitle(title) {
        return this.title
    }

    AddBottomControls() {
        buttonRowOffset := 10
        position := "x" . this.margin . " y+" . (this.margin + buttonRowOffset-2)
        this.AddManageButton("AddButton", position, "add", true)
        position := "x+" . (this.margin) . " yp+5 w60 h25"
        this.AddButton("vEditButton " . position, "Edit", "", "manageText")
        position := "x+" . this.margin . " yp w60 h25"
        this.AddButton("vBuildButton " . position, "Build", "", "manageText")
        this.AddButton("vRunButton " . position, "Run", "", "manageText")
        this.AddButton("vDeleteButton " . position, "Delete", "", "manageText")

        abMargin := this.margin/2
        toolsW := 50
        settingsW := 60
        smallH := 20
        bigH := 25
        actionButtonsW := toolsW + settingsW + abMargin

        actionButtonsX := (this.margin + this.windowSettings["contentWidth"] - actionButtonsW)
        position := "x" actionButtonsX . " yp-" . buttonRowOffset . " w" . toolsW . " h" . smallH . " Section"
        this.AddButton("vToolsButton " . position, "Tools")
        position := "x+" . abMargin . " yp w" . settingsW . " h" . smallH
        this.AddButton("vSettingsButton " . position, "Settings")
        position := "x" . actionButtonsX . " y+" . abMargin . " w" . actionButtonsW . " h" . bigH
        this.AddButton("vBuildAllButton " . position, "Build All", "", "primary")
    }

    GetStatusText() {
        return this.app.Auth.GetStatusText()
    }

    OnStatusIndicatorClick(btn, info) {
        if (this.app.Auth.IsAuthenticated()) {
            this.app.GuiManager.Dialog("AccountInfo", this.windowKey)
        } else {
            this.app.Auth.Login()
        }
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
        entity := this.app.GuiManager.Form("LauncherWizard", this.windowKey)

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
        this.app.GuiManager.Menu("AddMenu")
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
        this.app.GuiManager.Form("SettingsWindow")
    }

    OnToolsButton(btn, info) {
        this.app.GuiManager.Menu("ToolsWindow")
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
        this.AutoXYWH("xy*", ["SettingsButton", "ToolsButton"])
    }

    Destroy() {
        currentApp := this.app
        super.Destroy()
        currentApp.ExitApp()
    }
}
