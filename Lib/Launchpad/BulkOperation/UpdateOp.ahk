class UpdateOp extends InstallOp {
    progressTitle := "Updating Launchpad"
    progressText := "Please wait while Launchpad is updated..."
    successMessage := "Finished updating Launchpad."
    failedMessage := "However, there were errors during the update process. Please try reinstalling."

    RunInstallerAction(installer) {
        return installer.Update(this.progress)
    }
}
