class UpdateOp extends BulkOperationBase {
    installerKeys := ""
    progressTitle := "Updating Launchpad"
    progressText := "Please wait while Launchpad is updated..."
    successMessage := "Finished updating Launchpad."
    failedMessage := "However, there were errors during the update process. Please try reinstalling."

    __New(app, installerKeys, owner := "") {
        this.installerKeys := installerKeys
        super.__New(app, owner)
    }

    RunAction() {
        if (this.useProgress) {
            this.progress.SetRange(0, this.installerKeys.Length)
        }

        for index, installerKey in this.installerKeys {
            installer := this.app.Installers.GetInstaller(installerKey)
            this.StartItem(installer.name, installer.name . ": Updating...")
            this.results[installerKey] := installer.Update()
            this.FinishItem(key, true, key . ": Finished update.")
        }
    }
}
