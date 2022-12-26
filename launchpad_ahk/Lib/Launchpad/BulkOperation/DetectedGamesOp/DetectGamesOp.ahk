class DetectGamesOp extends BulkOperationBase {
    platforms := ""
    progressTitle := "Detecting Games"
    progressText := "Please wait while your games are detected..."
    shouldNotify := false
    successMessage := "Found games from {n} platforms."
    failedMessage := "Failed to detect games from {n} platforms."

    __New(app, platforms, owner := "") {
        this.platforms := platforms
        super.__New(app, owner)
    }

    RunAction() {
        if (this.useProgress) {
            this.progress.SetRange(0, this.platforms.Count)
        }

        for , platform in this.platforms {
            displayName := platform.Platform.displayName
            this.StartItem(displayName, "Detecting games from " . displayName . "...")
            this.results[displayName] := platform.DetectInstalledGames()
            this.FinishItem(displayName, true, "Finished detecting games from " . displayName . ".")
        }
    }
}
