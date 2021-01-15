class DetectedGamesWindow extends LaunchpadGuiBase {
    sidebarWidth := 85
    listViewColumns := Array("Name", "Action", "Is Known", "Install Dir", "Exe", "Launcher ID")
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
        this.AddButton("vAddSelectedButton xp y" . (this.windowSettings["listViewHeight"] - (this.margin * 2)) . " w" . this.sidebarWidth . " h40", "Add Selected", "", true)
    }

    AddDetectedGamesList() {
        styling := "C" . this.themeObj.GetColor("text")
        lvStyles := "+LV" . LVS_EX_LABELTIP . " +LV" . LVS_EX_AUTOSIZECOLUMNS . " +LV" . LVS_EX_DOUBLEBUFFER . " +LV" . LVS_EX_FLATSB . " -E0x200"
        lvStyles .= " +LV" . LVS_EX_TRANSPARENTBKGND . " +LV" . LVS_EX_TRANSPARENTSHADOWTEXT
        listViewWidth := this.windowSettings["contentWidth"] - this.sidebarWidth - this.margin
        lv := this.guiObj.AddListView("vListView w" . listViewWidth . " h" . this.windowSettings["listViewHeight"] . " " . styling . " Count" . this.detectedGames.Length . " Checked Section +Report " . lvStyles, this.listViewColumns)
        lv.OnEvent("ItemCheck", "OnItemCheck")
        lv.OnEvent("ItemSelect", "OnItemSelect")
        this.PopulateListView()
    }

    PopulateListView() {
        this.guiObj["ListView"].Delete()

        for index, detectedGameObj in this.detectedGames {
            if (!this.GameHasChanges(detectedGameObj)) {
                continue
            }

            isKnown := this.GameIsKnown(detectedGameObj) ? "Yes" : "No"
            this.guiObj["ListView"].Add(, detectedGameObj.key, "Ignore", isKnown, detectedGameObj.installDir, detectedGameObj.exeName, detectedGameObj.launcherSpecificId)
        }

        for index, col in this.listViewColumns {
            this.guiObj["ListView"].ModifyCol(index, "AutoHdr")
        }
    }

    GameHasChanges(detectedGameObj) {
        hasChanges := true

        if (this.GameExists(detectedGameObj) and this.launcherManager.Launchers.Has(detectedGameObj.key)) {
            hasChanges := detectedGameObj.HasChanges(this.launcherManager.Launchers[detectedGameObj.key])
        }

        return hasChanges
    }

    GameIsKnown(detectedGameObj) {
        return (this.launcherManager.Launchers.Has(detectedGameObj.key) || this.knownGames.Has(detectedGameObj.key))
    }

    GameExists(detectedGameObj) {
        gameStatus := false

        if (this.state.State.Has("DetectedGames") and this.state.State["DetectedGames"].Has(detectedGameObj.platform.displayName) and this.state.State["DetectedGames"][detectedGameObj.platform.displayName].Has(detectedGameObj.detectedKey)) {
            gameStatus := this.launcherManager.Launchers.Has(this.state.State["DetectedGames"][detectedGameObj.platform.displayName][detectedGameObj.detectedKey])
        }

        return gameStatus
    }

    OnItemCheck(LV, rowNum, isChecked)
    {
        key := LV.GetText(rowNum)

        action := "Ignore"

        if (isChecked) {
            action := this.launcherManager.Launchers.Has(key) ? "Modify Existing" : "Add New"
        }

        LV.Modify(rowNum,,, action)
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
    }

    OnUncheckAllButton(btn, info) {
        this.guiObj["ListView"].Modify(0, "-Check")
    }

    OnAddSelectedButton(btn, info) {
        rowNum := 0

        if (!this.state.State.Has("DetectedGames")) {
            this.state.State["DetectedGames"] := Map()
        }

        Loop {
            rowNum := this.guiObj["ListView"].GetNext(rowNum)

            if not rowNum {
                break
            }

            detectedGameObj := this.detectedGames[rowNum]

            if (this.launcherManager.Launchers.Has(detectedGameObj.key)) {
                detectedGameObj.UpdateLauncher(this.launcherManager.Launchers[detectedGameObj.key])
            } else {
                detectedGameObj.CreateLauncher(this.launcherManager)
            }

            if (!this.state.State["DetectedGames"].Has(detectedGameObj.platform.displayName)) {
                this.state.State["DetectedGames"][detectedGameObj.platform.displayName] := Map()
            }

            this.state.State["DetectedGames"][detectedGameObj.platform.displayName][detectedGameObj.detectedKey] := detectedGameObj.key
                
            Text := this.guiObj["ListView"].GetText(rowNum)
            MsgBox('The next selected row is #' rowNum ', whose first field is "' Text '".')
        }

        this.state.SaveState()
        this.launcherManager.SaveModifiedLaunchers()
        this.launcherManager.LoadLaunchers()
        ; @todo reload main Manage window, perhaps somewhere other than here.
    }

    EditDetectedGame(row) {
        detectedGameObj := this.detectedGames[row]

        modified := false ; @todo open Detected Game Editor and then set modified variable

        if (modified) {
            isKnown := this.GameIsKnown(detectedGameObj) ? "Yes" : "No"
            this.guiObj["ListView"].Modify(row,, detectedGameObj.key,, isKnown, detectedGameObj.installDir, detectedGameObj.exeName, detectedGameObj.launcherSpecificId)
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
