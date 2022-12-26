class FileBackup extends BackupBase {
    CreateBackup(backupNumber := 1) {
        if (this.source && FileExist(this.source)) {
            FileCopy(this.source, this.GetPath(backupNumber), true)
        }
    }

    RestoreBackup(backupNumber := 1) {
        if (this.source) {
            FileCopy(this.GetPath(backupNumber), this.source, true)
        }
    }
}
