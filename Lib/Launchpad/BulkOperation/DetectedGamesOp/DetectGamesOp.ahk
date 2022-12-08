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
            this.progress.SetRange(0, this.platforms.Length)
        }

        for platform in this.platforms {
            this.StartItem(platform.Platform.displayName, "Detecting games from " . platform.displayName . "...")
            this.results[platform.Platform.displayName] := platform.DetectInstalledGames()
            this.FinishItem(platform.Platform.displayName, true, "Finished detecting games from " . platform.displayName . ".")
        }
    }
}
