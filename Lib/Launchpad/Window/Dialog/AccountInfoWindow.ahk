class AccountInfoWindow extends LaunchpadFormGuiBase {
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

        ; @todo Add fields showing account information
    }

    ProcessResult(result) {
        if (result == "Logout") {
            this.app.Auth.Logout()
        }

        return result
    }
}
