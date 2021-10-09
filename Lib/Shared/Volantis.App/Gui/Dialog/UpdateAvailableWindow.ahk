class UpdateAvailableWindow extends FormGuiBase {
    releaseInfo := ""

    __New(app, themeObj, guiId, releaseInfo, owner := "", parent := "") {
        this.releaseInfo := releaseInfo
        super.__New(app, themeObj, guiId, "Update Available", this.GetTextDefinition(), owner, parent, this.GetButtonsDefinition())
    }

    GetTextDefinition() {
        return "There is a new version of Launchpad available!"
    }

    GetButtonsDefinition() {
        return "*&Update|&Cancel"
    }

    Controls() {
        global appVersion

        super.Controls()
        this.guiObj.AddText("w" . this.windowSettings["contentWidth"] . " y+" . (this.margin*2), "Current version: " . appVersion)
        this.SetFont("normal", "Bold")
        this.guiObj.AddText("w" . this.windowSettings["contentWidth"] . " y+" . (this.margin), "Latest version: " . this.releaseInfo["data"]["version"])
        this.SetFont()
        this.guiObj.AddLink("w" . this.windowSettings["contentWidth"] . " y+" . (this.margin), '<a href="' .  this.releaseInfo["data"]["release-page"] . '">View release notes</a>')
        this.guiObj.AddText("w" . this.windowSettings["contentWidth"] . " y+" . (this.margin*2), "Would you like to update " . this.app.appName . " now?")
    }

    ProcessResult(result, submittedData := "") {
        if (result == "Update") {
            this.ApplyUpdate()
        }

        return result
    }

    ApplyUpdate() {
        downloadUrl := this.releaseInfo["data"].Has("installer") ? this.releaseInfo["data"]["installer"] : ""
        
        if (!DirExist(this.app.tmpDir . "\Installers")) {
            DirCreate(this.app.tmpDir . "\Installers")
        }
        
        if (downloadUrl) {
            localFile := this.app.tmpDir . "\Installers\" . this.app.appName . "-" . this.releaseInfo["data"]["version"] . ".exe"
            FileDelete(this.app.tmpDir . "\Installers\" . this.app.appName . "-*")
            Download(downloadUrl, localFile)
            Run(localFile)
            this.app.ExitApp()
        }
    }
}
