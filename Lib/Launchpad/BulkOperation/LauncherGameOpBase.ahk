class LauncherGameOpBase extends BulkOperationBase {
    launcherEntities := ""
    verb := "processing"
    verbProper := "Processing"
    verbPast := "processed"
    verbPastProper := "Processed"
    progressTitle := ""
    progressText := ""
    successMessage := ""
    failedMessage := ""
    notify := true
    itemSuccessText := "Succeeded."
    itemFailedText := "Failed."

    __New(app, launcherEntities := "", owner := "") {
        if (this.progressTitle == "") {
            this.progressTitle := this.verbProper . " Launchers"
        }
        
        if (this.progressText == "") {
            this.progressText := "Please wait while your launchers are " . this.verbPast . "."
        }

        if (this.successMessage == "") {
            this.successMessage := this.verbPastProper . " {n} launcher(s) successfully."
        }

        if (this.failedMessage == "") {
            this.failedMessage := "{n} launcher(s) could not be " . this.verbPast . " due to errors."
        }

        if (launcherEntities == "") {
            launcherEntities := app.Launchers.Launchers
        }

        this.launcherEntities := launcherEntities

        super.__New(app, owner)
    }

    RunAction() {
        itemCount := this.launcherEntities.Count

        if (this.useProgress) {
            this.progress.SetRange(0, itemCount)
        }

        for key, launcherEntityObj in this.launcherEntities {
            this.StartItem(key, key . ": Discovering...")
            success := this.ProcessLauncherGame(launcherEntityObj)
            message := success ? this.itemSuccessText : this.itemFailedText
            this.FinishItem(key, success, key . ": " . message)
        }
    }

    ProcessLauncherGame(launcherEntityObj) {
        return true
    }

    VerifyRequirements() {
        if (this.app.Config.DestinationDir == "") {
            this.app.Notifications.Error("Launcher directory is not set.")
            return false
        }
        
        if (this.app.Config.AssetsDir == "") {
            this.app.Notifications.Error("Assets directory is not set.")
            return false
        }

        return true
    }
}
