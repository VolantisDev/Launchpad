class ManageBackupsWindow extends ManageWindowBase {
    listViewColumns := Array("KEY", "COUNT", "TOTAL SIZE")
    backupsFile := ""
    backupManager := ""

    __New(app, themeObj, windowKey, backupsFile := "", owner := "", parent := "") {
        if (backupsFile == "") {
            backupsFile := app.Config.BackupsFile
        }

        InvalidParameterException.CheckTypes("ManageBackupsWindow", "backupsFile", backupsFile, "")
        this.backupsFile := backupsFile
        this.backupManager := app.Service("BackupManager")
        this.lvCount := this.backupManager.CountEntities()
        super.__New(app, themeObj, windowKey, "Manage Backups", owner, parent)
    }

    AddBottomControls(y) {
        position := "x" . this.margin . " y" . y
        this.AddManageButton("AddButton", position, "add", true)
    }

    GetListViewData(lv) {
        data := Map()

        for key, backup in this.backupManager.Entities {
            data[key] := [backup.Key, backup.GetBackupCount(), backup.GetTotalSize()]
        }

        return data
    }

    ShouldHighlightRow(key, data) {
        return false
    }

    GetViewMode() {
        return this.app.Config.BackupsViewMode
    }

    GetListViewImgList(lv, large := false) {
        IL := IL_Create(this.backupManager.CountEntities(), 1, large)
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

    OnAddButton(btn, info) {
        this.AddBackup()
    }

    OnEditButton(btn, info) {
        selected := this.guiObj["ListView"].GetNext(, "Focused")

        if (selected > 0) {
            key := this.guiObj["ListView"].GetText(selected, 1)
            this.EditBackup(key)
        }
    }

    AddBackup() {
        ; TODO: Implement backup add operation
        ;entity := this.app.Service("GuiManager").Form("BackupWizard", this.windowKey)
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

        this.AutoXYWH("y", ["AddButton"])
    }

    ShowListViewContextMenu(lv, item, isRightClick, X, Y) {
        key := this.listView.GetRowKey(item)
        backup := this.backupManager.Entities[key]

        menuItems := []
        menuItems.Push(Map("label", "Edit", "name", "EditBackup"))
        menuItems.Push(Map("label", "Backup", "name", "BackupBackup"))
        menuItems.Push(Map("label", "Restore", "name", "RestoreBackup"))
        menuItems.Push(Map("label", "Delete", "name", "DeleteBackup"))

        result := this.app.Service("GuiManager").Menu("MenuGui", menuItems, this)

        if (result == "EditBackup") {
            this.EditBackup(key)
        } else if (result == "BackupBackup") {
            backup.CreateBackup()
            this.UpdateListView()
        } else if (result == "RestoreBackup") {
            backupNumber := 1
            backup.RestoreBackup(backupNumber)
            this.UpdateListView()
        } else if (result == "DeleteBackup") {
            ; TODO: Implement backup delete operation
        }
    }
}
