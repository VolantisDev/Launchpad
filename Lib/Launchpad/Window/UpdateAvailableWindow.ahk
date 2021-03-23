class UpdateAvailableWindow extends LaunchpadFormGuiBase {
    releaseInfo := ""

    __New(releaseInfo, app, windowKey := "", owner := "", parent := "") {
        this.releaseInfo := releaseInfo

        if (windowKey == "") {
            windowKey := "UpdateAvailableWindow"
        }

        if (owner == "") {
            owner := "MainWindow"
        }

        super.__New(app, "Update Available", this.GetTextDefinition(), windowKey, owner, parent, this.GetButtonsDefinition())
    }

    GetTextDefinition() {
        return "There is a new version of Launchpad available!" ; @todo Populate based on whether you're currently logged in
    }

    GetButtonsDefinition() {
        return "*&Update|&Cancel"
    }

    Controls() {
        global appVersion

        super.Controls()
        this.guiObj.AddText("w" . this.windowSettings["contentWidth"] . " y+" . (this.margin*2), "Latest version: " . this.releaseInfo["data"]["version"])
        this.guiObj.AddText("w" . this.windowSettings["contentWidth"] . " y+" . (this.margin), "Current version: " . appVersion)
        this.guiObj.AddText("w" . this.windowSettings["contentWidth"] . " y+" . (this.margin*2), "Would you like to update Launchpad now?")
    }

    ProcessResult(result) {
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
            localFile := this.app.tmpDir . "\Installers\Launchpad-" . this.releaseInfo["data"]["version"] . ".exe"
            Download(downloadUrl, localFile)
            Run(localFile)
            ExitApp()
        }
    }
}
