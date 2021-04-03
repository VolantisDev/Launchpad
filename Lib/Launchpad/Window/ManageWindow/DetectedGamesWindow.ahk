class DetectedGamesWindow extends ManageWindowBase {
    listViewColumns := Array("NAME", "ACTION", "PLATFORM", "STATUS", "API", "EXE")
    launcherManager := ""
    detectedGames := ""
    state := ""
    knownGames := ""
    checkboxes := true
    sidebarWidth := 0

    __New(app, themeObj, windowKey, detectedGames, owner := "", parent := "") {
        this.detectedGames := detectedGames
        this.state := app.State
        this.launcherManager := app.Launchers
        dataSource := app.DataSources.GetItem()
        this.knownGames := dataSource.ReadListing("game-keys")

        super.__New(app, themeObj, windowKey, "Detected Games", owner, parent)
    }

    AddBottomControls() {
        buttonRowOffset := 3
        position := "x" . this.margin . " y+" . (this.margin + buttonRowOffset) . " w60 h25"
        this.Add("ButtonControl", "vEditButton " . position, "Edit", "", "manageText")
        position := "x+" . (this.margin*3) . " yp w80 h25"
        this.Add("ButtonControl", "vCheckAllButton " . position, "Check All", "", "manageText")
        position := "x+" . this.margin . " yp w80 h25"
        this.Add("ButtonControl", "vUncheckAllButton " . position, "Uncheck All", "", "manageText")

        bigH := 30
        actionButtonsW := 120
        actionButtonsX := (this.margin + this.windowSettings["contentWidth"] - actionButtonsW)
        position := "x" . actionButtonsX . " yp-" . buttonRowOffset . " w" . actionButtonsW . " h" . bigH
        this.Add("ButtonControl", "vAddSelectedButton " . position, "Add Selected", "", "primary")
    }

    SetupManageEvents(lv) {
        lv.OnEvent("DoubleClick", "OnDoubleClick")
        lv.OnEvent("ItemCheck", "OnItemCheck")
        lv.OnEvent("ItemSelect", "OnItemSelect")
    }

    PopulateListView(focusedItem := 1) {
        this.guiObj["ListView"].Delete()

        for key, detectedGameObj in this.detectedGames {
            if (!this.GameHasChanges(detectedGameObj)) {
                ;continue
            }

            statusText := this.launcherManager.Entities.Has(detectedGameObj.key) ? "Exists" : "New"
            apiStatus := this.GameIsKnown(detectedGameObj) ? "Known" : "Unknown"
            this.guiObj["ListView"].Add(, detectedGameObj.key, "Ignore", detectedGameObj.platform.displayName, statusText, apiStatus, detectedGameObj.exeName)
        }

        this.guiObj["ListView"].ModifyCol(1, "Sort")

        this.guiObj["ListView"].ModifyCol(1, "AutoHdr")
        this.guiObj["ListView"].ModifyCol(2, "AutoHdr")
        this.guiObj["ListView"].ModifyCol(3, "AutoHdr")
        this.guiObj["ListView"].ModifyCol(4, "AutoHdr")
        this.guiObj["ListView"].ModifyCol(5, "AutoHdr")
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
        key := this.guiObj["ListView"].GetText(rowNum)

        action := "Ignore"

        if (isChecked) {
            action := this.launcherManager.Entities.Has(key) ? "Modify" : "Create"
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

        win := this.launcherManager.app.GuiManager.GetWindow("ManageWindow")
        win.PopulateListView()
        this.Destroy()
    }

    EditDetectedGame(row) {
        key := this.guiObj["ListView"].GetText(row)
        detectedGameObj := this.detectedGames[key]

        result := this.app.GuiManager.Form("DetectedGameEditor", detectedGameObj, this.windowKey)

        if (result == "Save") {
            if (key != detectedGameObj.key) {
                this.detectedGames.Delete(key)
                this.detectedGames[detectedGameObj.key] := detectedGameObj
            }

            statusText := this.launcherManager.Entities.Has(detectedGameObj.key) ? "Exists" : "New"
            apiStatus := this.GameIsKnown(detectedGameObj) ? "Known" : "Unknown"
            this.guiObj["ListView"].Modify(row,, detectedGameObj.key,, detectedGameObj.platform.displayName, statusText, apiStatus, detectedGameObj.exeName)
        }
    }

    OnSize(guiObj, minMax, width, height) {
        super.OnSize(guiObj, minMax, width, height)
        
        if (minMax == -1) {
            return
        }

        this.AutoXYWH("y", ["EditButton", "CheckAllButton", "UncheckAllButton"])
        this.AutoXYWH("xy", ["AddSelectedButton"])
    }
}
