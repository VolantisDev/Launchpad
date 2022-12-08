class AddDetectedGamesOp extends BulkOperationBase {
    detectedGames := ""
    launcherManager := ""
    state := ""
    progressTitle := "Adding Selected Games"
    progressText := "Please wait while Launchpad adds the selected games..."
    shouldNotify := true
    successMessage := "Added {n} games."
    failedMessage := "Failed to add {n} games."

    __New(app, detectedGames, launcherManager, state, owner := "") {
        this.detectedGames := detectedGames
        this.launcherManager := launcherManager
        this.state := state
        super.__New(app, owner)
    }

    RunAction() {
        if (this.useProgress) {
            this.progress.SetRange(0, this.detectedGames.Count)
        }

        if (!this.state.State.Has("DetectedGames")) {
            this.state.State["DetectedGames"] := Map()
        }

        for key, detectedGameObj in this.detectedGames {
            this.StartItem(detectedGameObj.key, "Adding " . detectedGameObj.key . "...")

            if (this.launcherManager.Has(detectedGameObj.key)) {
                detectedGameObj.UpdateLauncher(this.launcherManager[detectedGameObj.key])
            } else {
                detectedGameObj.CreateLauncher(this.launcherManager)
            }

            if (!this.state.State["DetectedGames"].Has(detectedGameObj.platform.displayName)) {
                this.state.State["DetectedGames"][detectedGameObj.platform.displayName] := Map()
            }

            this.state.State["DetectedGames"][detectedGameObj.platform.displayName][detectedGameObj.detectedKey] := detectedGameObj.key
            this.results[detectedGameObj.key] := true
            this.FinishItem(detectedGameObj.key, true, "Finished adding " . detectedGameObj.key . ".")
        }

        this.launcherManager.SaveModifiedEntities()
        this.state.SaveState()
        this.launcherManager.LoadComponents()
    }
}
