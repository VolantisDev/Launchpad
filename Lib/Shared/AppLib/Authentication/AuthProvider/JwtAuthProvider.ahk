class JwtAuthProvider extends AuthProviderBase {
    dataSourceObj := ""
    authEndpointUrl := ""
    webApiKey := ""
    refreshPath := "token"
    authToken := ""
    refreshToken := ""

    __New(dataSourceObj, authEndpointUrl, webApiKey, persistentData := "") {
        this.dataSourceObj := dataSourceObj
        this.authEndpointUrl := authEndpointUrl
        this.webApiKey := webApiKey

        if (persistentData != "" and persistentData.Has("authToken")) {
            this.authToken := persistentData["authToken"]
        }
    }

    Login() {
        refreshToken := this.refreshToken

        if (!refreshToken) {
            refreshToken := this.ShowLoginWindow()

            if (refreshToken) {
                this.refreshToken := refreshToken
            }
        }

        userInfo := ""

        if (refreshToken) {
            url := this.GetAuthUrl(this.refreshPath)
            request := WinHttpReq(url)
            payload := Map("grant_type", "refresh_token", "refresh_token", refreshToken)
            response := request.Send("POST", payload)
           
            if (response == -1 && request.GetStatusCode() == 200) {
                userInfo := this.ExtractAuthInfoFromResponse(request)
            } else {
                this.refreshToken := ""
                throw OperationFailedException("Login failed")
            }
        }

        return userInfo
    }

    GetAuthUrl(path) {
        return this.authEndpointUrl . "/" . path . "?key=" . this.webApiKey
    }

    ShowLoginWindow() {
        return ""
    }

    Logout(authInfoObj) {
        this.authToken := ""
        this.refreshToken := ""
        return true
    }

    RefreshAuthentication(authInfoObj) {
        refreshToken := authInfoObj.Get("refresh")

        if (refreshToken) {
            this.refreshToken := refreshToken
        }

        return this.Login()
    }

    IsAuthenticationValid(authInfoObj) {
        isValid := false

        if (authInfoObj && authInfoObj.Authenticated) {
            isValid := !this.IsAuthenticationExpired(authInfoObj)
        }

        return isValid
    }

    AddAuthInfoToRequest(authInfoObj, httpReqObj) {
        authToken := authInfoObj.Get("authToken")

        if (authToken) {
            this.AddAuthorizationHeader(authToken, httpReqObj)
        }
    }

    AddAuthorizationHeader(bearerToken, httpReqObj) {
        if (bearerToken) {
            httpReqObj.requestHeaders["Authorization"] := "Bearer " . bearerToken
        }
    }

    ExtractAuthInfoFromResponse(httpReqObj) {
        responseData := Trim(httpReqObj.GetResponseData())

        userInfo := Map()

        if (responseData) {
            data := JsonData()
            userInfo := data.FromString(&responseData)
        }

        return JwtAuthInfo(userInfo)
    }

    IsAuthenticationExpired(authInfoObj) {
        expired := true

        if (authInfoObj and authInfoObj.Authenticated) {
            expires := authInfoObj.Get("expires")

            if (expires) {
                diff := DateDiff(A_Now, expires, "S")
                expired := (diff >= 0)
            }
        }

        return expired
    }

    NeedsRefresh(authInfoObj) {
        needsRefresh := false
        thresholdSeconds := -600

        if (!this.IsAuthenticationValid(authInfoObj)) {
            needsRefresh := true
        } else {
            expires := authInfoObj.Get("expires")

            if (expires) {
                diff := DateDiff(A_Now, expires, "S")
                needsRefresh := (diff >= thresholdSeconds)
            } else {
                needsRefresh := true
            }
        }

        return needsRefresh
    }
}
