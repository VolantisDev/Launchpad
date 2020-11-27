class LoadLaunchersOp extends BulkOperationBase {
    launcherConfigObj := ""
    progressTitle := "Loading Launchers"
    progressText := "Please wait while your configuration is processed."
    successMessage := "Loaded {n} launcher(s) successfully."
    failedMessage := "{n} launcher(s) could not be loaded due to errors."

    __New(app, launcherConfigObj := "", owner := "") {
        if (launcherConfigObj == "") {
            launcherConfigObj := app.Launchers.GetLauncherConfig()
        }
        this.launcherConfigObj := launcherConfigObj

        super.__New(app, owner)
    }

    RunAction() {
        this.launcherConfigObj.LoadConfig()

        if (this.useProgress) {
            this.progress.SetRange(0, this.launcherConfigObj.Games.Count)
        }

        for key, config in this.launcherConfigObj.Games {
            this.StartItem(key, key . ": Loading...")
            requiredKeys := "" ; @todo Figure out if we need these or if they can just be passed in the config
            launcherEntityObj := LauncherEntity.new(this.app, key, config, requiredKeys)
            launcherEntityObj.MergeEntityDefaults()
            this.results[key] := launcherEntityObj
            this.FinishItem(key, true, key . ": Loaded successfully.")
        }
    }
}
