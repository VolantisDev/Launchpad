class BackupBase {
    key := ""
    source := ""
    config := Map()
    backupLimit := 5
    backupDir := A_Temp . "\Backups"
    baseFilename := ""

    __New(key, source, config := "") {
        this.key := key
        this.source := source

        if (config != "") {
            this.config := config

            if (config.Has("Limit")) {
                this.limit := config["Limit"]
            }

            if (config.Has("BackupDir")) {
                this.backupDir := config["BackupDir"]
            }

            if (config.Has("BaseFilename")) {
                this.baseFilename := config["BaseFilename"]
            }
        }

        if (!this.baseFilename) {
            this.baseFilename := this.key
        }
    }

    Backup() {
        this.Rotate()
        this.CreateBackup(1)
    }

    Rotate() {
        backupNumber := this.backupLimit

        while backupNumber > 0 {
            if (this.BackupExists(backupNumber) && backupNumber < this.backupLimit) {
                this.Move(backupNumber, backupNumber+1)
            }
        }
    }

    Restore(backupNumber := 1) {
        if (this.BackupExists(backupNumber)) {
            this.RestoreBackup(backupNumber)
        }
    }

    CreateBackup(backupNumber := 1) {

    }

    RestoreBackup(backupNumber := 1) {

    }

    BackupExists(backupNumber) {
        return !!(FileExist(this.GetPath(backupNumber)))
    }

    GetPath(backupNumber) {
        basePath := this.backupDir . "\" . this.baseFilename
        return basePath . "." . backupNumber
    }

    Move(fromNumber, toNumber) {
        this.Delete(toNumber)
        this.MoveBackup(fromNumber, toNumber)
    }

    MoveBackup(fromNumber, toNumber, overwrite := true) {
        fromPath := this.GetPath(fromNumber)

        if (FileExist(fromPath)) {
            FileMove(fromPath, this.GetPath(toNumber), overwrite)
        }
    }

    Delete(backupNumber) {
        if (this.BackupExists(backupNumber)) {
            FileDelete(this.GetPath(backupNumber))
        }

        while (this.BackupExists(backupNumber+1)) {
            this.MoveBackup(backupNumber+1, backupNumber)
            backupNumber++
        }
    }

    GetBackupCount() {
        backupNumber := 1
        count := 0

        while (backupNumber <= this.backupLimit) {
            if (this.BackupExists(backupNumber)) {
                count++
            }

            backupNumber++
        }

        return count
    }

    GetTotalSize(units := "") {
        backupNumber := 1
        size := 0

        while (backupNumber <= this.backupLimit) {
            size += this.GetBackupSize(backupNumber, units)
            backupNumber++
        }

        return size
    }

    GetBackupSize(backupNumber, units := "") {
        size := 0

        if (this.BackupExists(backupNumber)) {
            FileGetSize(this.GetPath(backupNumber), units)
        }

         return size
    }
}
