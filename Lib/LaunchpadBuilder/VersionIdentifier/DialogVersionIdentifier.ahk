class DialogVersionIdentifier extends VersionIdentifierBase {
    dialogTitle := "Launchpad Version"
    dialogText := "This is the version of Launchpad that will be built. Entering a new version will create a git tag, and if you later choose to make a GitHub release, the tag will be pushed to the repository."

    __New(app, repoPath := "") {
        super.__New(app)
    }

    IdentifyVersion(defaultVersion := "") {
        return this.app.GuiManager.Dialog("SingleInputBox", this.dialogTitle, this.dialogText, defaultVersion)
    }
}
