class ManageBackupsWindow extends ManageWindowBase {
    listViewColumns := Array("KEY", "COUNT", "TOTAL SIZE")
    backupManager := ""

    __New(container, themeObj, config) {
        this.backupManager := container.Get("entity_manager.backup")
        this.lvCount := this.backupManager.Count(true)
        super.__New(container, themeObj, config)
    }

    GetDefaultConfig(container, config) {
        defaults := super.GetDefaultConfig(container, config)
        defaults["title"] := "Manage Backups"
        defaults["backupsFile"] := container.Get("config.app")["backups_file"]
        return defaults
    }

    AddBottomControls(y) {
        position := "x" . this.margin . " y" . y
        this.AddManageButton("AddButton", position, "add", true)
    }

    GetListViewData(lv) {
        data := Map()

        for key, backup in this.backupManager {
            data[key] := [backup.Id, backup.GetBackupCount(), backup.GetTotalSize()]
        }

        return data
    }

    ShouldHighlightRow(key, data) {
        return false
    }

    GetViewMode() {
        return this.app.Config["backups_view_mode"]
    }

    GetListViewImgList(lv, large := false) {
        IL := IL_Create(this.backupManager.Count(true), 1, large)
        defaultIcon := this.themeObj.GetIconPath("backup")
        iconNum := 1

        for key, backup in this.backupManager {
            iconSrc := backup["IconSrc"]

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
        backupObj := this.backupManager[key]
        diff := backupObj.Edit("config", this.guiId)

        if (diff != "" && diff.HasChanges()) {
            backupObj.SaveEntity()
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
        backup := this.backupManager[key]

        menuItems := []
        menuItems.Push(Map("label", "Edit", "name", "EditBackup"))
        menuItems.Push(Map("label", "Backup", "name", "BackupBackup"))
        menuItems.Push(Map("label", "Restore", "name", "RestoreBackup"))
        menuItems.Push(Map("label", "Delete", "name", "DeleteBackup"))

        result := this.app["manager.gui"].Menu(menuItems, this)

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
