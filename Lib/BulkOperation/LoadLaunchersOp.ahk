class LoadLaunchersOp extends BulkOperationBase {
    launcherConfigObj := ""
    dataSource := ""
    progressTitle := "Loading Launchers"
    progressText := "Please wait while your configuration is processed."
    successMessage := "Loaded {n} launcher(s) successfully."
    failedMessage := "{n} launcher(s) could not be loaded due to errors."

    __New(app, launcherConfigObj := "", dataSource := "", owner := "") {
        if (launcherConfigObj == "") {
            launcherConfigObj := app.Launchers.GetLauncherConfig()
        }
        this.launcherConfigObj := launcherConfigObj

        if (dataSource == "") {
            dataSource := app.DataSources.GetDataSource()
        }
        this.dataSource := dataSource

        super.__New(app, owner)
    }

    RunAction() {
        this.launcherConfigObj.LoadConfig()

        if (this.useProgress) {
            this.progress.SetRange("0-" . this.launcherConfigObj.Games.Count)
        }

        for key, config in this.launcherConfigObj.Games {
            this.StartItem(key, key . ": Loading...")
            requiredKeys := "" ; @todo Figure out if we need these or if they can just be passed in the config
            launcherGame := EditableLauncherGame.new(this.app, key, config, requiredKeys, this.dataSource)
            launcherGame.MergeDefaults(true)
            this.results[key] := launcherGame
            this.FinishItem(key, true, key . ": Loaded successfully.")
        }
    }
}
