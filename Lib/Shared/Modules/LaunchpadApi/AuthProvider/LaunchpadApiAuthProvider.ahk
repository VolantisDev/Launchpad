class LaunchpadApiAuthProvider extends JwtAuthProvider {
    app := ""

    __New(app, stateObj) {
        this.app := app

        persistentData := ""

        if (stateObj) {
            state := stateObj.GetState()

            if (state.Has("Authentication")) {
                persistentData := state["Authentication"]
            }
        }

        authEndpointUrl := "https://securetoken.googleapis.com/v1"
        webApiKey := "AIzaSyCbwzOWJjTft77P96dV5VB3dAx9TjdDowQ"
        super.__New(app.Service("manager.datasource").GetDefaultDataSource(), authEndpointUrl, webApiKey, persistentData)
    }

    ShowLoginWindow() {
        return this.app.Service("GuiManager").Dialog(Map("type", "LoginWindow"))
    }

    ExtractAuthInfoFromResponse(httpReqObj) {
        authInfoObj := super.ExtractAuthInfoFromResponse(httpReqObj)
        return authInfoObj
    }
}
