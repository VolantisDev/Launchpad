
class UpdateAvailableWindow extends FormGuiBase {
    releaseInfo := ""

    __New(container, themeObj, config, releaseInfo) {
        this.releaseInfo := releaseInfo
        super.__New(container, themeObj, config)
    }

    GetDefaultConfig(container, config) {
        defaults := super.GetDefaultConfig(container, config)
        defaults["title"] := "Update Available"
        defaults["text"] := "There is a new version of " . container.GetApp().appName . " available!"
        defaults["buttons"] := "*&Update|&Cancel"
        return defaults
    }

    Controls() {
        global appVersion

        super.Controls()
        this.guiObj.AddText("w" . this.windowSettings["contentWidth"] . " y+" . (this.margin*2), "Current version: " . appVersion)
        this.SetFont("normal", "Bold")
        this.guiObj.AddText("w" . this.windowSettings["contentWidth"] . " y+" . (this.margin), "Latest version: " . this.releaseInfo["version"])
        this.SetFont()
        this.guiObj.AddLink("w" . this.windowSettings["contentWidth"] . " y+" . (this.margin), '<a href="' .  this.releaseInfo["release-page"] . '">View release notes</a>')
        this.guiObj.AddText("w" . this.windowSettings["contentWidth"] . " y+" . (this.margin*2), "Would you like to update " . this.app.appName . " now?")
    }

    ProcessResult(result, submittedData := "") {
        if (result == "Update") {
            this.ApplyUpdate()
        }

        return result
    }

    ApplyUpdate() {
        downloadUrl := this.releaseInfo.Has("installer") ? this.releaseInfo["installer"] : ""
        
        if (!DirExist(this.app.tmpDir . "\Installers")) {
            DirCreate(this.app.tmpDir . "\Installers")
        }
        
        if (downloadUrl) {
            localFile := this.app.tmpDir . "\Installers\" . this.app.appName . "-" . this.releaseInfo["version"] . ".exe"
            FileDelete(this.app.tmpDir . "\Installers\" . this.app.appName . "-*")
            Download(downloadUrl, localFile)
            Run(localFile)
            this.app.ExitApp()
        }
    }
}
