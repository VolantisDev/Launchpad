class ManageBackupsWindow extends ManageWindowBase {
    listViewColumns := Array("KEY", "COUNT", "TOTAL SIZE")
    backupsFile := ""
    backupManager := ""
    sidebarWidth := 0

    __New(app, themeObj, windowKey, backupsFile := "", owner := "", parent := "") {
        if (backupsFile == "") {
            backupsFile := app.Config.BackupsFile
        }

        InvalidParameterException.CheckTypes("ManageBackupsWindow", "backupsFile", backupsFile, "")
        this.backupsFile := backupsFile
        this.backupManager := app.Backups
        this.lvCount := this.backupManager.CountEntities()
        super.__New(app, themeObj, windowKey, "Manage Backups", owner, parent)
    }

    AddBottomControls() {
        buttonRowOffset := 10
        position := "x" . this.margin . " y+" . (this.margin + buttonRowOffset-2)
        this.AddManageButton("AddButton", position, "add", true)
        position := "x+" . (this.margin) . " yp+5 w60 h25"
        this.Add("ButtonControl", "vEditButton " . position, "Edit", "", "manageText")
        position := "x+" . this.margin . " yp w60 h25"
        this.Add("ButtonControl", "vBackupButton " . position, "Backup", "", "manageText")
        this.Add("ButtonControl", "vRestoreButton " . position, "Restore", "", "manageText")
        this.Add("ButtonControl", "vDeleteButton " . position, "Delete", "", "manageText")
    }

    GetListViewData(lv) {
        data := Map()

        for key, backup in this.backupManager.Entities {
            data[key] := [backup.Key, backup.GetBackupCount(), backup.GetTotalSize()]
        }

        return data
    }

    GetListViewImgList(lv) {
        IL := IL_Create(this.backupManager.CountEntities(), 1, false)
        defaultIcon := this.themeObj.GetIconPath("Backup")
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
        key := this.listView.GetRowKey(rowNum)
        this.EditBackup(key)
    }

    EditBackup(key) {
        backupObj := this.backupManager.Entities[key]
        diff := backupObj.Edit("config", this.guiObj)

        if (diff != "" && diff.HasChanges()) {
            this.backupManager.SaveModifiedEntities()
            this.UpdateListView()
        }
    }

    OnItemSelect(LV, rowNum, selected) {
        this.numSelected += (selected) ? 1 : -1
    }

    GetSelectedBackup() {
        selected := this.guiObj["ListView"].GetNext()
        backup := ""

        if (selected > 0) {
            key := this.listView.GetRowKey(selected)
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
            backup.CreateBackup()
            this.UpdateListView()
        }
    }

    OnRestoreButton(btn, info) {
        backup := this.GetSelectedBackup()
        
        if (backup) {
            ; @Todo implement Backup Selector window
            ;backupNumber := this.app.GuiManager.Dialog("BackupSelector", backup, this.windowKey)
            backupNumber := 1
            backup.RestoreBackup(backupNumber)
            this.UpdateListView()
        }
    }

    OnReloadButton(btn, info) {
        this.backupManager.LoadComponents()
        this.UpdateListView()
    }

    OnEditButton(btn, info) {
        selected := this.guiObj["ListView"].GetNext(, "Focused")

        if (selected > 0) {
            key := this.guiObj["ListView"].GetText(selected, 1)
            this.EditBackup(key)
        }
    }

    OnDeleteButton(btn, info) {
        ; @todo implement backup deletion
    }

    AddBackup() {
        ; @todo Add Backup Wizard
        ;entity := this.app.GuiManager.Form("BackupWizard", this.windowKey)
        entity := ""

        if (entity != "") {
            this.backupManager.AddEntity(entity.Key, entity)
            this.backupManager.SaveModifiedEntities()
            this.UpdateListView()
        }
    }

    OnSize(guiObj, minMax, width, height) {
        super.OnSize(guiObj, minMax, width, height)
        
        if (minMax == -1) {
            return
        }

        this.AutoXYWH("y", ["AddButton", "BackupButton", "RestoreButton", "EditButton", "DeleteButton"])
    }
}
