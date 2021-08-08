class LoadBackupsOp extends BulkOperationBase {
    backupsConfigObj := ""
    progressTitle := "Loading Backups"
    progressText := "Please wait while your backups are processed."
    successMessage := "Loaded {n} backup(s) successfully."
    failedMessage := "{n} backup(s) could not be loaded due to errors."

    __New(app, backupsConfigObj := "", owner := "") {
        if (backupsConfigObj == "") {
            backupsConfigObj := app.Service("BackupManager").GetConfig()
        }

        InvalidParameterException.CheckTypes("LoadBackupsOp", "backupsConfigObj", backupsConfigObj, "BackupsConfig")
        this.backupsConfigObj := backupsConfigObj
        super.__New(app, owner)
    }

    RunAction() {
        this.backupsConfigObj.LoadConfig()

        if (this.useProgress) {
            this.progress.SetRange(0, this.backupsConfigObj.Backups.Count)
        }

        for key, config in this.backupsConfigObj.Backups {
            this.StartItem(key, key)
            requiredKeys := ""
            this.results[key] := BackupEntity(this.app, key, config, requiredKeys)
            this.FinishItem(key, true, key . ": Loaded successfully.")
        }
    }
}
