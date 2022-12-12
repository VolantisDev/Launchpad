﻿class AccountInfoWindow extends FormGuiBase {
    GetDefaultConfig(container, config) {
        defaults := super.GetDefaultConfig(container, config)
        defaults["title"] := "Account Info"
        defaults["buttons"] := "*&Save|&Cancel|&Logout"
        return defaults
    }

    Controls() {
        super.Controls()

        if (this.app.Services.Has("entity_manager.web_service")) {
            entityMgr := this.app.Services["entity_manager.web_service"]

            if (entityMgr.Has("api") && entityMgr["api"]["Enabled"]) {
                info := Map(
                    "name", "",
                    "email", "",
                    "photo", ""
                )

                ; @todo Pull this information from the API web service
    
                if (info) {
                    opts := "w" . this.windowSettings["contentWidth"] . " x" . this.margin . " y+" . this.margin
                    this.guiObj.AddPicture("x" . this.margin . " y+" . this.margin, info["photo"])
                    this.guiObj.AddText(opts, "Email: " . info["email"])
                }
            }
        }

        this.AddHeading("Player Name")
        this.AddEdit("PlayerName", this.app.Config["player_name"], "", 250)
        this.guiObj.AddText("w" . this.windowSettings["contentWidth"], "Note: Player name is stored locally and not synced with your online Launchpad account yet.")

        position := "Wrap x" . this.margin . " y+" . this.margin
        options := position . " w" . this.windowSettings["contentWidth"] . " +0x200 c" . this.themeObj.GetColor("textLink")
        this.guiObj.AddLink(options, 'Manage your account at <a href="https://launchpad.games/profile">launchpad.games</a>.')
    }

    ProcessResult(result, submittedData := "") {
        

        if (result == "Logout") {
            if (this.app.Services.Has("entity_manager.web_service")) {
                entityMgr := this.app.Services["entity_manager.web_service"]
    
                if (entityMgr.Has("api") && entityMgr["api"]["Enabled"]) {
                    entityMgr["api"].Logout()
                }
            }
        } else if (result == "Save" && submittedData) {
            this.app.Config["player_name"] := submittedData.PlayerName
        }

        return result
    }
}
