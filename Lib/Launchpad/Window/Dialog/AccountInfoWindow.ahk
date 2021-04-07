class AccountInfoWindow extends FormGuiBase {
    __New(app, themeObj, windowKey, owner := "", parent := "") {
        super.__New(app, themeObj, windowKey, "Account Info", this.GetTextDefinition(), owner, parent, this.GetButtonsDefinition())
    }

    GetTextDefinition() {
        return ""
    }

    GetButtonsDefinition() {
        return "*&Save|&Cancel|&Logout"
    }

    Controls() {
        super.Controls()

        info := this.app.Auth.GetStatusInfo()

        if (info) {
            opts := "w" . this.windowSettings["contentWidth"] . " x" . this.margin . " y+" . this.margin
            this.guiObj.AddPicture("x" . this.margin . " y+" . this.margin, info["photo"])
            this.guiObj.AddText(opts, "Email: " . info["email"])
        }

        this.AddHeading("Player Name")
        this.AddEdit("PlayerName", this.app.Config.PlayerName, "", 250)
        this.guiObj.AddText("w" . this.windowSettings["contentWidth"], "Note: Player name is stored locally and not synced with your online Launchpad account yet.")

        position := "Wrap x" . this.margin . " y+" . this.margin
        options := position . " w" . this.windowSettings["contentWidth"] . " +0x200 c" . this.themeObj.GetColor("linkText")
        this.guiObj.AddLink(options, 'Manage your account at <a href="https://launchpad.games/profile">launchpad.games</a>.')
    }

    ProcessResult(result, submittedData := "") {
        if (result == "Logout") {
            this.app.Auth.Logout()
        } else if (result == "Save" && submittedData) {
            this.app.Config.PlayerName := submittedData.PlayerName
        }

        return result
    }
}
