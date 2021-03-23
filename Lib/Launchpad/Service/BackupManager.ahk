class BackupManager extends AppComponentServiceBase {
    _registerEvent := LaunchpadEvents.BACKUPS_REGISTER
    _alterEvent := LaunchpadEvents.BACKUPS_ALTER
    backupDir := ""

    __New(app, backupDir, components := "") {
        InvalidParameterException.CheckTypes("BackupManager", "backupDir", backupDir, "")
        InvalidParameterException.CheckEmpty("BackupManager", "backupDir", backupDir)
        this.backupDir := backupDir
        
        super.__New(app, components)
    }

    LoadComponents() {
        if (!this._componentsLoaded) {
            ; @todo Load backups
        }

        super.LoadComponents()
    }

    SetBackupDir(backupDir) {
        this.app.Config.BackupDir := backupDir
        this.backupDir := this.app.Config.BackupDir
    }

    ChangeBackupDir() {
        backupDir := DirSelect("*" . this.app.Config.BackupDir, 3, "Create or select the folder to save Launchpad's backups to")
        
        if (backupDir != "") {
            this.SetBackupDir(backupDir)
        }

        return backupDir
    }

    OpenBackupDir() {
        Run(this.backupDir)
    }
}
