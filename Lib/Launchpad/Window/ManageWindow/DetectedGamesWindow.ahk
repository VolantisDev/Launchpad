class DetectedGamesWindow extends ManageWindowBase {
    listViewColumns := Array("NAME", "ACTION", "PLATFORM", "STATUS", "API", "EXE")
    launcherManager := ""
    detectedGames := ""
    state := ""
    knownGames := ""
    checkboxes := true

    __New(app, themeObj, windowKey, detectedGames, owner := "", parent := "") {
        this.detectedGames := detectedGames
        this.state := app.State
        this.launcherManager := app.Service("LauncherManager")
        dataSource := app.Service("DataSourceManager").GetItem()
        this.knownGames := dataSource.ReadListing("game-keys")

        super.__New(app, themeObj, windowKey, "Detected Games", owner, parent)
    }

    AddBottomControls() {
        buttonRowOffset := 3
        position := "x" . this.margin . " y+" . (this.margin + buttonRowOffset) . " w80 h25"
        this.Add("ButtonControl", "vCheckAllButton " . position, "Check All", "", "manageText")
        position := "x+" . this.margin . " yp w80 h25"
        this.Add("ButtonControl", "vUncheckAllButton " . position, "Uncheck All", "", "manageText")

        bigH := 30
        actionButtonsW := 120
        actionButtonsX := (this.margin + this.windowSettings["contentWidth"] - actionButtonsW)
        position := "x" . actionButtonsX . " yp-" . buttonRowOffset . " w" . actionButtonsW . " h" . bigH
        this.Add("ButtonControl", "vAddSelectedButton " . position, "Add Selected", "", "primary")
    }

    InitListView(lv) {
        super.InitListView(lv)
        lv.ctl.OnEvent("ItemCheck", "OnItemCheck")
    }

    GetListViewData(lv) {
        data := Map()

        checked := lv.GetSelected("Checked", true)

        for key, detectedGameObj in this.detectedGames {
            if (!this.GameHasChanges(detectedGameObj)) {
                ;continue
            }

            statusText := this.launcherManager.Entities.Has(detectedGameObj.key) ? "Exists" : "New"
            apiStatus := this.GameIsKnown(detectedGameObj) ? "Known" : "Unknown"
            
            isChecked := false
            for index, checkedKey in checked {
                if (checkedKey == detectedGameObj.key) {
                    isChecked := true
                    break
                }
            }

            action := "Ignore"

            if (isChecked) {
                action := this.launcherManager.Entities.Has(key) ? "Modify" : "Create"
            }

            data[detectedGameObj.key] := [detectedGameObj.key, action, detectedGameObj.platform.displayName, statusText, apiStatus, detectedGameObj.exeName]
        }

        return data
    }

    GetListViewImgList(lv, large := false) {
        IL := IL_Create(this.detectedGames.Count, 1, large)
        defaultIcon := this.themeObj.GetIconPath("Game")
        iconNum := 1

        for key, detectedGameObj in this.detectedGames {
            iconSrc := detectedGameObj.exeName

            if (!iconSrc or !FileExist(iconSrc)) {
                iconSrc := defaultIcon
            }

            IL_Add(IL, iconSrc)
            iconNum++
        }

        return IL
    }

    GameHasChanges(detectedGameObj) {
        hasChanges := true

        if (this.GameExists(detectedGameObj) && this.launcherManager.Entities.Has(detectedGameObj.key)) {
            hasChanges := detectedGameObj.HasChanges(this.launcherManager.Entities[detectedGameObj.key])
        }

        return hasChanges
    }

    GameIsKnown(detectedGameObj) {
        known := false

        for (index, key in this.knownGames) {
            if (key == detectedGameObj.key) {
                known := true
                break
            }
        }
        return known
    }

    GameExists(detectedGameObj) {
        gameStatus := false

        if (this.state.State.Has("DetectedGames") && this.state.State["DetectedGames"].Has(detectedGameObj.platform.displayName) && this.state.State["DetectedGames"][detectedGameObj.platform.displayName].Has(detectedGameObj.detectedKey)) {
            gameStatus := this.launcherManager.Entities.Has(this.state.State["DetectedGames"][detectedGameObj.platform.displayName][detectedGameObj.detectedKey])
        }

        return gameStatus
    }

    OnItemCheck(LV, rowNum, isChecked) {
        this.UpdateRowAction(rowNum, isChecked)
    }

    UpdateRowAction(rowNum, isChecked) {
        key := this.listView.GetRowKey(rowNum)

        action := "Ignore"

        if (isChecked) {
            action := this.launcherManager.Entities.Has(key) ? "Modify" : "Create"
        }

        this.listView.ctl.Modify(rowNum,,,, action)
    }

    OnDoubleClick(LV, rowNum) {
        if (rowNum > 0) {
            key := this.listView.GetRowKey(rowNum)
            this.EditDetectedGame(key)
        }
    }

    OnCheckAllButton(btn, info) {
        this.guiObj["ListView"].Modify(0, "+Check")

        Loop this.detectedGames.Count {
            this.UpdateRowAction(A_Index, true)
        }
    }

    OnUncheckAllButton(btn, info) {
        this.guiObj["ListView"].Modify(0, "-Check")

        Loop this.detectedGames.Count {
            this.UpdateRowAction(A_Index, false)
        }
    }

    OnAddSelectedButton(btn, info) {
        rowNum := 0
        games := Map()

        Loop {
            rowNum := this.guiObj["ListView"].GetNext(rowNum, "C")

            if !rowNum {
                break
            }

            key := this.guiObj["ListView"].GetText(rowNum)
            games[key] := this.detectedGames[key]
        }

        op := AddDetectedGamesOp.new(this.app, games, this.launcherManager, this.state, "DetectedGamesWindow")
        op.Run()

        win := this.launcherManager.app.Service("GuiManager").GetWindow("MainWindow")
        win.UpdateListView()
        this.Destroy()
    }

    EditDetectedGame(key) {
        if (!key) {
            throw AppException.new("Detected game key could not be determined.")
        }

        detectedGameObj := this.detectedGames[key]

        result := this.app.Service("GuiManager").Form("DetectedGameEditor", detectedGameObj, this.windowKey)

        if (result == "Save") {
            if (key != detectedGameObj.key) {
                this.detectedGames.Delete(key)
                this.detectedGames[detectedGameObj.key] := detectedGameObj
            }

            this.listView.UpdateListView()
        }
    }

    OnSize(guiObj, minMax, width, height) {
        super.OnSize(guiObj, minMax, width, height)
        
        if (minMax == -1) {
            return
        }

        this.AutoXYWH("y", ["CheckAllButton", "UncheckAllButton"])
        this.AutoXYWH("xy", ["AddSelectedButton"])
    }

    ShowListViewContextMenu(lv, item, isRightClick, X, Y) {
        key := this.listView.GetRowKey(item)

        menuItems := []
        menuItems.Push(Map("label", "Edit", "name", "EditDetectedGame"))

        result := this.app.Service("GuiManager").Menu("MenuGui", menuItems, this)

        if (result == "EditDetectedGame") {
            this.EditDetectedGame(key)
        }
    }
}
