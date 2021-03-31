class AccountInfoWindow extends FormGuiBase {
    __New(app, themeObj, windowKey, owner := "", parent := "") {
        super.__New(app, themeObj, windowKey, "Account Info", this.GetTextDefinition(), owner, parent, this.GetButtonsDefinition())
    }

    GetTextDefinition() {
        return "" ; @todo Populate based on whether you're currently logged in
    }

    GetButtonsDefinition() {
        return "*&OK|&Logout"
    }

    Controls() {
        super.Controls()

        this.AddHeading("Player Name")
        this.AddEdit("PlayerName", this.app.Config.PlayerName, "", 250)
        this.guiObj.AddText("w" . this.windowSettings["contentWidth"], "Note: Player name is stored locally and not synced with your online Launchpad account yet.")

        ; @todo Add fields showing account information
    }

    ProcessResult(result, submittedData := "") {
        if (result == "Logout") {
            this.app.Auth.Logout()
        } else if (result == "OK" && submittedData) {
            this.app.Config.PlayerName := submittedData.PlayerName
        }

        return result
    }
}
