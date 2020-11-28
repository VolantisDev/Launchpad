class InstallOp extends BulkOperationBase {
    installerKeys := ""
    progressTitle := "Installing Requirements"
    progressText := "Please wait while Launchpad finishes setting up..."
    successMessage := "Installed {n} requirements(s) successfully."
    failedMessage := "{n} requirements(s) could not be loaded due to errors."

    __New(app, installerKeys, owner := "") {
        this.installerKeys := installerKeys
        super.__New(app, owner)
    }

    RunAction() {
        if (this.useProgress) {
            this.progress.SetRange(0, this.CountInstallerAssets())
        }

        for index, installerKey in this.installerKeys {
            installer := this.app.Installers.GetInstaller(installerKey)
            this.StartItem(installer.name, installer.name . ": Running...")
            this.results[installerKey] := installer.InstallOrUpdate()
            this.FinishItem(key, true, key . ": Finished.")
        }
    }

    CountInstallerAssets() {
        count := 0

        for index, installerKey in this.installerKeys {
            installer := this.app.Installers.GetInstaller(installerKey)
            count += installer.CountAssets()
        }

        return count
    }
}
