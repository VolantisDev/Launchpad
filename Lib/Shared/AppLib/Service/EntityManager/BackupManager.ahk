class BackupManager extends EntityManagerBase {
    _registerEvent := "" ;Events.BACKUPS_REGISTER
    _alterEvent := "" ;Events.BACKUPS_ALTER

    GetLoadOperation() {
        return LoadBackupsOp(this.app, this.configObj)
    }

    CreateConfigObj(app, configFile) {
        return BackupsConfig(app, configFile, false)
    }

    GetDefaultConfigPath() {
        return this.app.Config.BackupsFile
    }

    RemoveEntityFromConfig(key) {
        this.configObj.Backups.Delete(key)
    }

    AddEntityToConfig(key, entityObj) {
        this.configObj.Backups[key] := entityObj.UnmergedConfig
        this.configObj.SaveConfig()
    }

    SetBackupDir(backupDir) {
        this.app.Config.BackupDir := backupDir
    }

    ChangeBackupDir() {
        backupDir := DirSelect("*" . this.app.Config.BackupDir, 3, "Create or select the folder to save " . this.app.appName . "'s backups to")
        
        if (backupDir != "") {
            this.SetBackupDir(backupDir)
        }

        return backupDir
    }

    OpenBackupDir() {
        Run(this.app.Config.BackupDir)
    }

    CreateBackupEntity(key, config) {
        backup := BackupEntity(this.app, key, config)
        this.AddEntity(key, backup)
        return backup
    }
}
