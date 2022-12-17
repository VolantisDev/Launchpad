/**
 * @todo finish implementing and make it an option in the normal entity loading phase
 */
class LoadEntitiesOp extends BulkOperationBase {
    launcherManager := ""
    launcherConfigObj := ""
    progressTitle := "Loading Launchers"
    progressText := "Please wait while your launchers are processed..."
    successMessage := "Loaded {n} launcher(s) successfully."
    failedMessage := "{n} launcher(s) could not be loaded due to errors."

    __New(app, launcherConfigObj := "", owner := "") {
        this.launcherManager := app["entity_manager.launcher"]

        if (launcherConfigObj == "") {
            launcherConfigObj := this.launcherManager.GetConfig()
        }

        InvalidParameterException.CheckTypes("EntityBase", "launcherConfigObj", launcherConfigObj, "LauncherConfig")
        this.launcherConfigObj := launcherConfigObj
        super.__New(app, owner)
    }

    RunAction() {
        this.launcherConfigObj.LoadConfig()

        if (this.useProgress) {
            this.progress.SetRange(0, this.launcherConfigObj.Count)
        }

        ; @todo replace this since EntityFactory is no longer used
        factory := this.app["EntityFactory"]

        for key, config in this.launcherConfigObj {
            this.StartItem(key, key)
            requiredKeys := ""
            this.results[key] := factory.CreateEntity("LauncherEntity", key, config, "", requiredKeys)

            if (!this.app.State.GetLauncherCreated(key)) {
                this.app.State.SetLauncherCreated(key)
            }

            this.FinishItem(key, true, key . ": Loaded successfully.")
        }
    }
}
