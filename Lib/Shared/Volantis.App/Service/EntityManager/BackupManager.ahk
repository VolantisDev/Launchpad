class BackupManager extends EntityManagerBase {
    _registerEvent := Events.BACKUPS_REGISTER
    _alterEvent := Events.BACKUPS_ALTER

    GetLoadOperation() {
        return LoadBackupsOp(this.app, this.configObj)
    }

    GetDefaultConfigPath() {
        return this.app.Config["backups_file"]
    }

    RemoveEntityFromConfig(key) {
        this.configObj.Delete(key)
    }

    AddEntityToConfig(key, entityObj) {
        this.configObj[key] := entityObj.UnmergedConfig
        this.configObj.SaveConfig()
    }

    SetBackupDir(backupDir) {
        this.app.Config["backup_dir"] := backupDir
    }

    ChangeBackupDir() {
        backupDir := DirSelect("*" . this.app.Config["backup_dir"], 3, "Create or select the folder to save " . this.app.appName . "'s backups to")
        
        if (backupDir != "") {
            this.SetBackupDir(backupDir)
        }

        return backupDir
    }

    OpenBackupDir() {
        Run(this.app.Config["backup_dir"])
    }

    CreateBackupEntity(key, config) {
        ; TODO: Use the entity factory here
        backup := BackupEntity(this.app, key, config)
        this.AddEntity(key, backup)
        return backup
    }
}
