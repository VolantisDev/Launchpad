class InstallOp extends BulkOperationBase {
    installerKeys := ""
    progressTitle := "Initializing Launchpad"
    progressText := "Please wait while Launchpad finishes initializing..."
    successMessage := "Finished initializing Launchpad."
    failedMessage := "{n} requirements(s) could not be loaded due to errors."

    __New(app, installerKeys, owner := "") {
        this.installerKeys := installerKeys
        super.__New(app, owner)
    }

    RunAction() {
        if (this.useProgress) {
            this.progress.SetRange(0, this.CountInstallerItems())
        }

        for index, installerKey in this.installerKeys {
            installer := this.app.Installers.GetInstaller(installerKey)
            this.StartItem(installer.name, installer.name . " running...")
            this.results[installerKey] := this.RunInstallerAction(installer)
            this.FinishItem(installer.name, true, installer.name . " finished.")
        }
    }

    RunInstallerAction(installer) {
        return installer.InstallOrUpdate(this.progress)
    }

    CountInstallerItems() {
        count := this.installerKeys.Length

        for index, installerKey in this.installerKeys {
            installer := this.app.Installers.GetInstaller(installerKey)
            count += installer.CountAssets()
        }

        return count
    }
}
