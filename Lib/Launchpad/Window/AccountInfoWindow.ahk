class AccountInfoWindow extends LaunchpadFormGuiBase {
    __New(app, windowKey := "", owner := "", parent := "") {
        if (windowKey == "") {
            windowKey := "AccountInfoWindow"
        }

        if (owner == "") {
            owner := "MainWindow"
        }

        super.__New(app, "Account Info", this.GetTextDefinition(), windowKey, owner, parent, this.GetButtonsDefinition())
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
