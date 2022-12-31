class LauncherGameOpBase extends BulkOperationBase {
    launcherManager := ""
    launcherEntities := ""
    verb := "processing"
    verbProper := "Processing"
    verbPast := "processed"
    verbPastProper := "Processed"
    progressTitle := ""
    progressText := ""
    successMessage := ""
    failedMessage := ""
    shouldNotify := true
    itemSuccessText := "Succeeded."
    itemFailedText := "Failed."

    __New(app, launcherEntities := "", owner := "") {
        this.launcherManager := app["entity_manager.launcher"]
        
        if (launcherEntities == "") {
            launcherEntities := this.launcherManager.All()
        }

        InvalidParameterException.CheckTypes("LauncherGameOpBase", "launcherEntities", launcherEntities, "Map")

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
        if (this.app.Config["destination_dir"] == "") {
            this.app["notifier"].Error("Launcher directory is not set.")
            return false
        }
        
        if (this.app.Config["assets_dir"] == "") {
            this.app["notifier"].Error("Assets directory is not set.")
            return false
        }

        return true
    }
}
