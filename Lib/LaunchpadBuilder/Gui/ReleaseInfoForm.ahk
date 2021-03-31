class ReleaseInfoForm extends FormGuiBase {
    __New(app, themeObj, windowKey, owner := "", parent := "") {
        super.__New(app, themeObj, windowKey, "Release Info", this.GetTextDefinition(), owner, parent, this.GetButtonsDefinition())
    }

    GetTextDefinition() {
        return "Fill in the information below and click Upload to send the release to your configured source(s). Click Cancel if you do not wish to push the release anywhere at this time."
    }

    GetButtonsDefinition() {
        return "*&Upload|&Cancel"
    }

    Controls() {
        super.Controls()

        this.AddHeading("Release Version")
        this.guiObj.AddText("vVersion xs y+" . this.margin . " w" . this.windowSettings["contentWidth"], this.app.Version)

        this.AddHeading("Release Title")
        this.guiObj.AddEdit("vReleaseTitle xs y+m r1 w" . this.windowSettings["contentWidth"] . " c" . this.themeObj.GetColor("editText"), this.app.appName . " " . this.app.Version)

        this.AddHeading("Release Notes")
        this.guiObj.AddEdit("vReleaseNotes xs y+m r10 w" . this.windowSettings["contentWidth"] . " c" . this.themeObj.GetColor("editText"))

        this.AddHeading("Release Options")
        this.AddCheckBox("Create as draft", "CreateAsDraft", true, false, "OnCheckbox")
        this.AddCheckBox("Mark as prerelease", "MarkAsPrerelease", false, false, "OnCheckbox")

        this.AddHeading("Deployment Options")
        this.AddCheckBox("Deploy release info to GitHub", "DeployToGitHub", this.app.Config.DeployRelease, false, "OnCheckbox")
        this.AddCheckBox("Deploy release to Launchpad.games API", "DeployToApi", this.app.Config.DeployRelease, false, "OnCheckbox")
    }

    ProcessResult(result, submittedData := "") {
        result := (result == "Upload") ? this.GetReleaseInfo() : ""
    }

    GetReleaseInfo() {
        releaseInfo := Map()

        return releaseInfo
    }
}
