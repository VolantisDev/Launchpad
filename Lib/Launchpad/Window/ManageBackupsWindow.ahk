class ManageBackupsWindow extends ManageWindowBase {
    listViewColumns := Array("KEY", "ENABLED", "COUNT", "TOTAL SIZE")
    backupsFile := ""
    backupManager := ""
    backupRows := []
    sidebarWidth := 0

    __New(app, backupsFile := "", windowKey := "", owner := "", parent := "") {
        if (backupsFile == "") {
            backupsFile := app.Config.BackupsFile
        }

        InvalidParameterException.CheckTypes("ManageBackupsWindow", "backupsFile", backupsFile, "")
        this.backupsFile := backupsFile
        this.backupManager := app.Backups
        this.lvCount := this.backupManager.CountEntities()
        super.__New(app, "Manage Backups", windowKey, owner, parent)
    }

    AddBottomControls() {
        buttonRowOffset := 10
        position := "x" . this.margin . " y+" . (this.margin + buttonRowOffset-2)
        this.AddManageButton("AddButton", position, "add", true)
        position := "x+" . (this.margin) . " yp+5 w60 h25"
        this.AddButton("vEditButton " . position, "Edit", "", "manageText")
        position := "x+" . this.margin . " yp w60 h25"
        this.AddButton("vBackupButton " . position, "Backup", "", "manageText")
        this.AddButton("vRestoreButton " . position, "Restore", "", "manageText")
        this.AddButton("vDeleteButton " . position, "Delete", "", "manageText")
    }

    SetupManageEvents(lv) {
        lv.OnEvent("DoubleClick", "OnDoubleClick")
    }

    PopulateListView(focusedItem := 1) {
        this.guiObj["ListView"].Delete()
        this.guiObj["ListView"].SetImageList(this.CreateIconList())
        iconNum := 1
        index := 1
        this.backupRows := []

        for key, backup in this.backupManager.Entities {
            enabledText := backup.IsEnabled ? "Yes" : "No"
            focusOption := index == focusedItem ? " Focus" : ""
            this.guiObj["ListView"].Add("Icon" . iconNum . focusOption, backup.Key, enabledText, backup.GetBackupCount(), backup.GetTotalSize())
            this.backupRows.Push(key)
            iconNum++
            index++
        }

        for index, col in this.listViewColumns {
            this.guiObj["ListView"].ModifyCol(index, "AutoHdr")
        }
    }

    CreateIconList() {
        IL := IL_Create(this.backupManager.CountEntities(), 1, false)
        defaultIcon := A_ScriptDir . "\Resources\Graphics\Backup.ico"
        
        iconNum := 1
        for key, backup in this.backupManager.Entities {
            iconSrc := backup.IconSrc

            if (!iconSrc or !FileExist(iconSrc)) {
                iconSrc := defaultIcon
            }

            IL_Add(IL, iconSrc)
            iconNum++
        }

        return IL
    }

    OnDoubleClick(LV, rowNum) {
        key := this.backupRows[rowNum]
        this.EditBackup(key)
    }

    EditBackup(key) {
        backupObj := this.backupManager.Entities[key]
        diff := backupObj.Edit("config", this.guiObj)

        if (diff != "" && diff.HasChanges()) {
            this.backupManager.SaveModifiedEntities()
            this.PopulateListView()
        }
    }

    OnItemSelect(LV, rowNum, selected) {
        this.numSelected += (selected) ? 1 : -1
    }

    GetSelectedBackup() {
        selected := this.guiObj["ListView"].GetNext()
        backup := ""

        if (selected > 0) {
            key := this.backupRows[selected]
            backup := this.backupManager.Entities[key]
        }

        return backup
    }

    OnAddButton(btn, info) {
        this.AddBackup()
    }

    OnBackupButton(btn, info) {
        backup := this.GetSelectedBackup()
        
        if (backup) {
            selected := this.guiObj["ListView"].GetNext(, "Focused")
            backup.CreateBackup()
            this.PopulateListView()

            if (selected) {
                this.guiObj["ListView"].Modify(selected, "Select")
            }
        }
    }

    OnRestoreButton(btn, info) {
        backup := this.GetSelectedBackup()
        
        if (backup) {
            selected := this.guiObj["ListView"].GetNext(, "Focused")
            backupNumber := this.app.Windows.BackupSelector(backup)
            backup.RestoreBackup(backupNumber)
            this.PopulateListView()

            if (selected) {
                this.guiObj["ListView"].Modify(selected, "Select")
            }
        }
    }

    OnReloadButton(btn, info) {
        this.backupManager.LoadComponents()
        this.PopulateListView()
    }

    OnEditButton(btn, info) {
        selected := this.guiObj["ListView"].GetNext(, "Focused")

        if (selected > 0) {
            key := this.guiObj["ListView"].GetText(selected, 1)
            this.EditBackup(key)
        }
    }

    AddBackup() {
        entity := this.app.Windows.BackupWizard(this.guiObj)

        if (entity != "") {
            this.backupManager.AddEntity(entity.Key, entity)
            this.backupManager.SaveModifiedEntities()
            this.PopulateListView()
        }
    }

    OnSize(guiObj, minMax, width, height) {
        super.OnSize(guiObj, minMax, width, height)
        
        if (minMax == -1) {
            return
        }

        this.AutoXYWH("y", ["AddButton", "BackupButton", "RestoreButton", "EditButton", "DeleteButton"])
        
        for index, col in this.listViewColumns {
            this.guiObj["ListView"].ModifyCol(index, "AutoHdr")
        }
    }
}
