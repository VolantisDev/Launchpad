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

        for platformEnt in this.platforms {
            key := platformEnt.Id
            platform := platformEnt.platform
            this.StartItem(platform.displayName, "Detecting games from " . platform.displayName . "...")
            this.results[platform.displayName] := platform.DetectInstalledGames()
            this.FinishItem(platform.displayName, true, "Finished detecting games from " . platform.displayName . ".")
        }
    }
}
