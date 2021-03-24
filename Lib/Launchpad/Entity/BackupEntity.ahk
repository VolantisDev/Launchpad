class BackupEntity extends EntityBase {
    backup := ""

    IsEditable {
        get => this.GetConfigValue("IsEditable")
        set => this.SetConfigValue("IsEditable", !!(value))
    }

    IconSrc {
        get => this.GetConfigValue("IconSrc")
        set => this.SetConfigValue("IconSrc", value)
    }

    Source {
        get => this.GetConfigValue("Source")
        set => this.SetConfigValue("Source", value)
    }

    BackupLimit {
        get => this.GetConfigValue("BackupLimit")
        set => this.SetConfigValue("BackupLimit", value)
    }

    BackupDir {
        get => this.GetConfigValue("BackupDir")
        set => this.SetConfigValue("BackupDir", value)
    }

    BaseFilename {
        get => this.GetConfigValue("BaseFilename")
        set => this.SetConfigValue("BaseFilename", value)
    }

    BackupClass {
        get => this.GetConfigValue("BackupClass")
        set => this.SetConfigValue("BackupClass", value)
    }
    
    IsEnabled {
        get => this.GetConfigValue("IsEnabled")
        set => this.SetConfigValue("IsEnabled", !!(value))
    }

    __New(app, key, config, requiredConfigKeys := "", parentEntity := "") {
        super.__New(app, key, config, requiredConfigKeys, parentEntity)
        backupClass := config.Has("BackupClass") ? config["BackupClass"] : "FileBackup"

        if (!this.backup) {
            this.CreateBackupObject(backupClass)
        }
    }

    InitializeDefaults() {
        defaults := super.InitializeDefaults()
        defaults["DataSourceKeys"] := []
        defaults["IsEditable"] := true
        defaults["Source"] := ""
        defaults["BackupLimit"] := this.app.Config.BackupsToKeep
        defaults["BackupDir"] := this.app.Config.BackupDir
        defaults["BaseFilename"] := this.Key
        defaults["BackupClass"] := "FileBackup"
        defaults["IsEnabled"] := true
        defaults["IconSrc"] := A_ScriptDir . "\Resources\Graphics\Backup.ico"
        return defaults
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
            backupClass := this.BackupClass
        }

        this.backup := %backupClass%.new(this.Key, this.Source, this.Config)
    }

    SetConfigValue(key, value) {
        super.SetConfigValue(key, value)
        this.CreateBackupObject()
    }

    AutoDetectValues() {
        if (!this.backup) {
            this.CreateBackupObject()
        }

        detectedValues := super.AutoDetectValues()
        return detectedValues
    }

    GetBackupObject() {
        return this.backup
    }

    LaunchEditWindow(mode, owner := "", parent := "") {
        return this.app.Windows.BackupEditor(this, mode, owner, parent)
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
