class AuthService extends AppServiceBase {
    authProviderObj := ""
    stateObj := ""
    authenticationEnabled := false
    authInfoObj := ""

    __New(app, authProviderObj, stateObj) {
        InvalidParameterException.CheckTypes("AuthenticationService", "stateObj", stateObj, "StateBase")
        this.authProviderObj := authProviderObj
        this.stateObj := stateObj

        authState := this.stateObj.Authentication

        if (authState && authState.Count > 0) {
            authInfoObj := AuthInfo()
            authInfoObj.Authenticated := true
            
            for key, value in authState {
                authInfoObj.Set(key, value, true)
            }

            this.authInfoObj := authInfoObj
        }

        super.__New(app)
    }

    SetAuthProvider(authProviderObj) {
        this.authProviderObj := authProviderObj
    }

    SetState(stateObj) {
        this.stateObj := stateObj
    }

    Login() {
        if (this.app.Config["api_authentication"] && this.authProviderObj) {
            authInfoObj := ""

            if (!this.IsAuthenticated()) {
                authInfoObj := this.authProviderObj.Login()
            } else if (this.AuthenticationNeedsRefresh()) {
                authInfoObj := this.RefreshAuthentication()
            }

            if (authInfoObj) {
                this.UpdateAuthState(authInfoObj)
                this.app.UpdateStatusIndicators()
            }
        }
    }

    GetStatusInfo() {
        statusText := "Not logged in"
        imgPath := ""
        email := ""

        if (this.IsAuthenticated()) {
            playerName := this.app.Config["player_name"]
            email := this.authInfoObj.Get("email")
            
            if (playerName) {
                statusText := playerName
            } else if (email) {
                statusText := email
            } else {
                statusText := "Logged in"
            }

            imgPath := this.authInfoObj.Get("photo")

            if (SubStr(imgPath, 1, 4) == "http") {
                cachePath := "account--profile.jpg"
                imgPath := this.app.Service("manager.cache")["file"].GetCachedDownload(cachePath, imgPath)
            }
        }

        return Map("name", statusText, "email", email, "photo", imgPath)
    }

    Logout() {
        if (this.app.Config["api_authentication"] && this.authProviderObj && this.authInfoObj) {
            this.authProviderObj.Logout(this.authInfoObj)
            this.authInfoObj := ""
            this.stateObj.Authentication := Map()
            this.app.UpdateStatusIndicators()
        }
    }

    IsAuthenticated() {       
        return this.app.Config["api_authentication"] && this.authProviderObj && this.authInfoObj && this.authInfoObj.Authenticated
    }

    AuthenticationNeedsRefresh() {
        needsRefresh := false

        if (this.app.Config["api_authentication"] && this.authProviderObj && this.IsAuthenticated()) {
            needsRefresh := this.authProviderObj.NeedsRefresh(this.authInfoObj)
        }

        return needsRefresh
    }

    RefreshAuthentication() {
        if (this.app.Config["api_authentication"] && this.authProviderObj && this.IsAuthenticated()) {
            authInfoObj := this.authProviderObj.RefreshAuthentication(this.authInfoObj)

            if (authInfoObj) {
                this.UpdateAuthState(authInfoObj)
            }
        }
    }

    UpdateAuthState(authInfoObj) {
        if (this.app.Config["api_authentication"] && this.authProviderObj && authInfoObj) {
            this.authInfoObj := authInfoObj
            this.AddUserInfoFromApi(authInfoObj)
            this.stateObj.SetAuthentication(authInfoObj.GetPersistentData())
        }
    }

    AddUserInfoFromApi(authInfoObj) {
        dataSource := this.app.Service("DataSourceManager")["api"]

        if (dataSource) {
            apiStatus := dataSource.GetStatus()

            if (apiStatus) {
                if (apiStatus.Has("email")) {
                    authInfoObj.Set("email", apiStatus["email"], true)
                }

                if (apiStatus.Has("photo")) {
                    authInfoObj.Set("photo", apiStatus["photo"], true)
                }
            }
        }
    }

    AlterApiRequest(request) {
        if (this.IsAuthenticated()) {
            if (this.AuthenticationNeedsRefresh()) {
                this.RefreshAuthentication()
            }

            this.authProviderObj.AddAuthInfoToRequest(this.authInfoObj, request)
        }
    }
}
