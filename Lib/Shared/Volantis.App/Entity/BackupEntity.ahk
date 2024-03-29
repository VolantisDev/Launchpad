class BackupEntity extends AppEntityBase {
    backup := ""

    __New(app, key, config, parentEntity := "", requiredConfigKeys := "") {
        super.__New(app, key, config, parentEntity, requiredConfigKeys)
        backupClass := config.Has("BackupClass") ? config["BackupClass"] : "FileBackup"

        if (!this.backup) {
            this.CreateBackupObject(backupClass)
        }
    }

    BaseFieldDefinitions() {
        definitions := super.BaseFieldDefinitions()

        if (definitions.Has("DataSourceKeys")) {
            definitions["DataSourceKeys"]["default"] := []
        }

        definitions["IsEditable"] := Map(
            "type", "boolean",
            "default", true
        )

        definitions["IconSrc"] := Map(
            "type", "icon_file",
            "description", "The path to this an icon (.ico or .exe).",
            "default", this.app.Service("manager.theme")[].GetIconPath("Backup")
        )

        definitions["Source"] := Map(
            "default", ""
        )

        definitions["BackupLimit"] := Map(
            "type", "number",
            "numberType", "Integer",
            "min", 0,
            "max", 100,
            "default", this.app.Config["backups_to_keep"]
        )

        definitions["BackupDir"] := Map(
            "type", "directory",
            "required", true,
            "default", this.app.Config["backup_dir"]
        )

        definitions["BaseFilename"] := Map(
            "default", this.Id
        )

        definitions["BackupClass"] := Map(
            "default", "FileBackup"
        )

        definitions["IsEnabled"] := Map(
            "type", "boolean",
            "required", false,
            "default", true
        )

        return definitions
    }

    GetBackupCount() {
        count := 0

        if (this.backup) {
            count := this.backup.GetBackupCount()
        }

        return count
    }

    GetTotalSize() {
        totalSize := 0

        if (this.backup) {
            totalSize := this.backup.GetTotalSize("K")
        }

        return totalSize . " KB"
    }

    CreateBackupObject(backupClass := "") {
        if (backupClass == "") {
            backupClass := this["BackupClass"]
        }

        this.backup := %backupClass%(this.Id, this["Source"], this.FieldData)
    }

    SetConfigValue(key, value) {
        super.SetConfigValue(key, value)
        this.CreateBackupObject()
    }

    AutoDetectValues(recurse := true) {
        if (!this.backup) {
            this.CreateBackupObject()
        }

        detectedValues := super.AutoDetectValues(recurse)
        return detectedValues
    }

    GetBackupObject() {
        return this.backup
    }

    CreateBackup() {
        if (this.backup) {
            this.backup.Backup()
        }
    }

    RestoreBackup(backupNumber := 1) {
        if (this.backup) {
            this.backup.Restore(backupNumber)
        }
    }
}
