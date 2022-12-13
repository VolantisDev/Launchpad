class AccountInfoWindow extends FormGuiBase {
    GetDefaultConfig(container, config) {
        defaults := super.GetDefaultConfig(container, config)
        defaults["title"] := "Account Info"
        defaults["buttons"] := "*&Save|&Cancel|&Logout"
        defaults["webService"] := ""
        return defaults
    }

    Controls() {
        super.Controls()

        if (this.app.Services.Has("entity_manager.web_service")) {
            entityMgr := this.app.Services["entity_manager.web_service"]

            webService := this.config["webService"]

            if (!webService) {
                throw AppException("Opened AccountInfoWindow without a webService specified.")
            }

            info := webService.GetStatusInfo()

            if (info) {
                opts := "w" . this.windowSettings["contentWidth"] . " x" . this.margin . " y+" . this.margin
                this.guiObj.AddPicture("x" . this.margin . " y+" . this.margin, info["photo"])
                this.guiObj.AddText(opts, "Email: " . info["email"])
            }
        }

        position := "Wrap x" . this.margin . " y+" . this.margin
        options := position . " w" . this.windowSettings["contentWidth"] . " +0x200 c" . this.themeObj.GetColor("textLink")
        this.guiObj.AddLink(options, 'Manage your account at <a href="https://launchpad.games/profile">launchpad.games</a>.')
    }

    ProcessResult(result, submittedData := "") {
        if (result == "Logout") {
            webService := this.config["webService"]

            if (webService) {
                webService.Logout()
            }
        } else if (result == "Login") {
            webService := this.config["webService"]

            if (webService) {
                webService.Login()
            }
        }

        return result
    }
}
