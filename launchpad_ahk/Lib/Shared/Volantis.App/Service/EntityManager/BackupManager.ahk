class BackupManager extends EntityManagerBase {
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
}
