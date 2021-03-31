class LoginWindow extends FormGuiBase {
    entityObj := ""
    entityManager := ""
    missingFields := Map()
    dataSource := ""
 
    __New(app, themeObj, windowKey, owner := "", parent := "") {
        super.__New(app, themeObj, windowKey, "Login", this.GetTextDefinition(), owner, parent, this.GetButtonsDefinition())
    }

    GetTextDefinition() {
        return "Logging in allows enhanced features such as online backup, restore, personalization, and sharing with the community.`n`nIf you'd like to log in, click the `"Get token`" button to go to the launchpad.games site to retrieve a valid login token and then paste it below."
    }

    GetButtonsDefinition() {
        return "*&Login|&Cancel"
    }

    Controls() {
        super.Controls()
        this.AddButton("xs y+m vGetAuthToken w150 h30", "Get Token")
        this.AddHeading("Login Token")
        this.guiObj.AddEdit("vAuthToken xs y+m r1 w" . this.windowSettings["contentWidth"] . " c" . this.themeObj.GetColor("editText"))
    }

    OnGetAuthToken(btn, info) {
        Run("https://launchpad.games/profile")
    }

    ProcessResult(result, submittedData := "") {
        return (result == "Login") ? this.guiObj["AuthToken"].Text : ""
    }
}
