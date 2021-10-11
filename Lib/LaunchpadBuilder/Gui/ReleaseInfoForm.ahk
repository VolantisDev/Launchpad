class ReleaseInfoForm extends FormGuiBase {
    GetDefaultConfig(container, config) {
        defaults := super.GetDefaultConfig(container, config)
        defaults["title"] := "Release Info"
        defaults["text"] := "Fill in the information below and click Upload to send the release to your configured source(s). Click Cancel if you do not wish to push the release anywhere at this time."
        defaults["buttons"] := "*&Upload|&Cancel"
        return defaults
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
    }

    ProcessResult(result, submittedData := "") {
        return (result == "Upload") ? submittedData : ""
    }
}
