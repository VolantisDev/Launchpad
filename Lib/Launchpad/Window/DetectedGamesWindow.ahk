class DetectedGamesWindow extends LaunchpadGuiBase {
    sidebarWidth := 85
    listViewColumns := Array("Name", "Action", "Is Known", "Platform", "Install Dir", "Exe", "Launcher ID")
    launcherManager := ""
    launchersModified := false
    numSelected := 0
    detectedGames := ""
    state := ""
    knownGames := ""

    __New(app, detectedGames, windowKey := "", owner := "", parent := "") {
        this.detectedGames := detectedGames
        this.state := app.AppState
        this.launcherManager := app.Launchers
        dataSource := app.DataSources.GetItem()
        this.knownGames := dataSource.ReadListing("Games")

        super.__New(app, "Detected Games", windowKey, owner, parent)
    }

    Controls() {
        super.Controls()
        this.AddDetectedGamesList()
        this.AddButton("vCheckAllButton ys w" . this.sidebarWidth . " h30", "Check All")
        this.AddButton("vUncheckAllButton xp y+m w" . this.sidebarWidth . " h30", "Uncheck All")
        this.AddButton("vEditButton xp y+" . (this.margin * 2) . " w" . this.sidebarWidth . " h30 Hidden", "Edit")
        this.AddButton("vAddSelectedButton xp y" . (this.windowSettings["listViewHeight"] - (this.margin * 3)) . " w" . this.sidebarWidth . " h40", "Add Selected", "", true)
    }

    AddDetectedGamesList() {
        styling := "C" . this.themeObj.GetColor("text")
        lvStyles := "+LV" . LVS_EX_LABELTIP . " +LV" . LVS_EX_AUTOSIZECOLUMNS . " +LV" . LVS_EX_DOUBLEBUFFER . " +LV" . LVS_EX_FLATSB . " -E0x200"
        lvStyles .= " +LV" . LVS_EX_TRANSPARENTBKGND . " +LV" . LVS_EX_TRANSPARENTSHADOWTEXT
        listViewWidth := this.windowSettings["contentWidth"] - this.sidebarWidth - this.margin
        lv := this.guiObj.AddListView("vListView w" . listViewWidth . " h" . this.windowSettings["listViewHeight"] . " " . styling . " Count" . this.detectedGames.Count . " Checked Section +Report " . lvStyles, this.listViewColumns)
        lv.OnEvent("ItemCheck", "OnItemCheck")
        lv.OnEvent("ItemSelect", "OnItemSelect")
        this.PopulateListView()
    }

    PopulateListView() {
        this.guiObj["ListView"].Delete()

        for key, detectedGameObj in this.detectedGames {
            if (!this.GameHasChanges(detectedGameObj)) {
                continue
            }

            isKnown := this.GameIsKnown(detectedGameObj) ? "Yes" : "No"
            this.guiObj["ListView"].Add(, detectedGameObj.key, "Ignore", isKnown, detectedGameObj.platform.displayName, detectedGameObj.installDir, detectedGameObj.exeName, detectedGameObj.launcherSpecificId)
        }

        this.guiObj["ListView"].ModifyCol(1, "Sort")
        this.guiObj["ListView"].ModifyCol(1, "AutoHdr")
        this.guiObj["ListView"].ModifyCol(2, "AutoHdr")
        this.guiObj["ListView"].ModifyCol(3, "AutoHdr")
        this.guiObj["ListView"].ModifyCol(4, "AutoHdr")

        ;for index, col in this.listViewColumns {
        ;    this.guiObj["ListView"].ModifyCol(index, "AutoHdr")
        ;}

        ;this.guiObj["ListView"].ModifyCol()
    }

    GameHasChanges(detectedGameObj) {
        hasChanges := true

        if (this.GameExists(detectedGameObj) && this.launcherManager.Launchers.Has(detectedGameObj.key)) {
            hasChanges := detectedGameObj.HasChanges(this.launcherManager.Launchers[detectedGameObj.key])
        }

        return hasChanges
    }

    GameIsKnown(detectedGameObj) {
        return (this.launcherManager.Launchers.Has(detectedGameObj.key) || this.knownGames.Has(detectedGameObj.key))
    }

    GameExists(detectedGameObj) {
        gameStatus := false

        if (this.state.State.Has("DetectedGames") && this.state.State["DetectedGames"].Has(detectedGameObj.platform.displayName) && this.state.State["DetectedGames"][detectedGameObj.platform.displayName].Has(detectedGameObj.detectedKey)) {
            gameStatus := this.launcherManager.Launchers.Has(this.state.State["DetectedGames"][detectedGameObj.platform.displayName][detectedGameObj.detectedKey])
        }

        return gameStatus
    }

    OnItemCheck(LV, rowNum, isChecked) {
        this.UpdateRowAction(rowNum, isChecked)
    }

    UpdateRowAction(rowNum, isChecked) {
        key := this.guiObj["ListView"].GetText(rowNum)

        action := "Ignore"

        if (isChecked) {
            action := this.launcherManager.Launchers.Has(key) ? "Modify Existing" : "Add New"
        }

        this.guiObj["ListView"].Modify(rowNum,,, action)
    }

    OnItemSelect(LV, rowNum, selected) {
        this.numSelected += (selected) ? 1 : -1
        buttonState := this.numSelected > 0 ? "-Hidden" : "+Hidden"
        this.guiObj["EditButton"].Opt(buttonState)
    }

    OnEditButton(btn, info) {
        rowNum := this.guiObj["ListView"].GetNext()

        if (rowNum > 0) {
            this.EditDetectedGame(rowNum)
        }
        
    }

    OnDoubleClick(LV, rowNum) {
        if (rowNum > 0) {
            this.EditDetectedGame(rowNum)
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
            this.UpdateRowAction(A_Index, true)
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

        win := this.launcherManager.app.Windows.GetItem("ManageWindow")
        win.launchersModified := true
        win.PopulateListView()
        this.Destroy()
    }

    EditDetectedGame(row) {
        key := this.guiObj["ListView"].GetText(row)
        detectedGameObj := this.detectedGames[key]

        result := this.app.Windows.DetectedGameEditor(detectedGameObj, "DetectedGamesWindow")

        if (result == "Save") {
            isKnown := this.GameIsKnown(detectedGameObj) ? "Yes" : "No"
            this.guiObj["ListView"].Modify(row,, detectedGameObj.key,, isKnown, detectedGameObj.platform.displayName, detectedGameObj.installDir, detectedGameObj.exeName, detectedGameObj.launcherSpecificId)
        }
    }

    OnSize(guiObj, minMax, width, height) {
        if (minMax == -1) {
            return
        }

        this.AutoXYWH("wh", ["ListView"])
        this.AutoXYWH("x", ["EditButton", "CheckAllButton", "UncheckAllButton"])
        this.AutoXYWH("xy", ["AddSelectedButton"])
    }
}
