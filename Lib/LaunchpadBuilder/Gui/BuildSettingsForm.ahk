class BuildSettingsForm extends FormGuiBase {
    version := ""

    __New(app, themeObj, windowKey, version := "", owner := "", parent := "") {
        if (version == "") {
            version := app.Version
        }
        
        this.version := version
        super.__New(app, themeObj, windowKey, "Build Settings", this.GetTextDefinition(), owner, parent, this.GetButtonsDefinition())
    }

    GetTextDefinition() {
        return "Fill in the information below and click Build to start the build process."
    }

    GetButtonsDefinition() {
        return "*&Build|&Cancel"
    }

    Controls() {
        super.Controls()

        this.AddHeading("Application Version")
        this.guiObj.AddText("y+" (this.margin/2) . " w" . this.windowSettings["contentWidth"], "This is the version that will be built. Entering a new version will create a git tag, and if you later choose to make a GitHub release, the tag will be pushed to the repository.")
        this.AddEdit("Version", this.version, "", 150)

        this.AddHeading("Build Options")
        this.AddCheckBox("Build installer", "BuildInstaller", true, false, "OnCheckbox")
        this.AddCheckBox("Build chocolatey package", "BuildChocoPkg", true, false, "OnCheckbox")

        this.AddHeading("Deployment Options")
        this.AddCheckBox("Deploy release to GitHub", "DeployToGitHub", false, false, "OnCheckbox")
        this.AddCheckBox("Deploy release to Launchpad.games API", "DeployToApi", false, false, "OnCheckbox")
        this.AddCheckBox("Deploy chocolatey package", "DeployToChocolatey", false, false, "OnCheckbox")
    }

    ProcessResult(result, submittedData := "") {
        return (result == "Build") ? submittedData : ""
    }
}
