class LauncherGameOpBase extends BulkOperationBase {
    launcherGames := ""
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

    __New(app, launcherGames := "", owner := "") {
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

        if (launcherGames == "") {
            launcherGames := app.Launchers.Launchers
        }

        this.launcherGames := launcherGames

        super.__New(app, owner)
    }

    RunAction() {
        itemCount := this.launcherGames.Count

        if (this.useProgress) {
            this.progress.SetRange(0, itemCount)
        }

        for key, launcherGame in this.launcherGames {
            this.StartItem(key, key . ": Discovering...")
            success := this.ProcessLauncherGame(launcherGame)
            message := success ? this.itemSuccessText : this.itemFailedText
            this.FinishItem(key, success, key . ": " . message)
        }
    }

    ProcessLauncherGame(launcherGame) {
        return true
    }

    VerifyRequirements() {
        if (this.app.Config.LauncherDir == "") {
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
