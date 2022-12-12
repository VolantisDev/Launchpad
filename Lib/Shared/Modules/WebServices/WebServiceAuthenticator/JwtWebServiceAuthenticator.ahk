class JwtWebServiceAuthenticator extends WebServiceAuthenticatorBase {
    Login(webServiceEnt, retryCount := 0) {
        if (retryCount > this.maxRetries) {
            throw OperationFailedException("Login failed after " . retryCount . " tries.")
        }

        authResult := ""

        if (!this._hasRefreshToken(webServiceEnt)) {
            authResult := this._reauthenticate(webServiceEnt)
        }

        success := false

        if (authResult != "Cancel") {
            if (this._hasRefreshToken(webServiceEnt)) {
                success := this._refreshAuthentication(webServiceEnt)
            }            

            if (!success) {
                success := this.Login(webServiceEnt, retryCount + 1)
            }
        }

        return success
    }

    Logout(webServiceEnt) {
        webServiceEnt
            .ResetAuthData()
            .DeleteAuthData("auth_token", true)
            .DeleteAuthData("refresh_token", true)
            .DeleteAuthData("expires", true)
            .SetAuthData("authenticated", false, true)


        return true
    }

    RefreshAuthentication(webServiceEnt) {
        if (this.NeedsRefresh(webServiceEnt)) {
            this.Login(webServiceEnt)
        }
    }

    AlterRequest(webServiceEnt, request, httpReqObj) {
        bearerToken := webServiceEnt.AuthData["auth_token"]

        if (bearerToken) {
            httpReqObj.requestHeaders["Authorization"] := "Bearer " . bearerToken
        }
    }

    _hasRefreshToken(webServiceEnt) {
        return !!(webServiceEnt.AuthData["refresh_token"])
    }

    _reauthenticate(webServiceEnt) {
        refreshToken := this._authenticationGui(webServiceEnt)

        if (refreshToken != "Cancel") {
            this._setRefreshToken(webServiceEnt, refreshToken)
        }

        return refreshToken
    }

    _getRefreshToken(webServiceEnt) {
        return webServiceEnt.AuthData["refresh_token"]
    }

    _setRefreshToken(webServiceEnt, refreshToken) {
        webServiceEnt.SetAuthData("refresh_token", refreshToken, true)
    }

    _extractAuthData(webServiceEnt, response) {
        loginData := response.GetJsonData()

        if (!loginData.Has("authenticated")) {
            loginData["authenticated"] := !!(loginData.Has("refresh_token") && loginData["refresh_token"])
        }

        keyMap := Map(
            "id_token", "auth_token", 
            "expires_in", "expires"
        )

        persistentKeys := [
            "user_id",
            "refresh_token",
            "auth_token",
            "access_token",
            "authenticated",
            "expires"
        ]

        expiresInKeys := [
            "expires"
        ]

        skipKeys := []

        for key, val in loginData {
            if (keyMap.Has(key)) {
                key := keyMap[key]
            }

            persist := false

            for , persistKey in persistentKeys {
                if (key == persistKey) {
                    persist := true
                    break
                }
            }

            expires := false

            for , expiresKey in expiresInKeys {
                if (key == expiresKey) {
                    val := DateAdd(A_Now, val, "S")
                    break
                }
            }

            skip := false
            
            for , skipKey in skipKeys {
                if (key == skipKey) {
                    skip := true
                    break
                }
            }

            if (!skip) {
                webServiceEnt.SetAuthData(key, val, persist)
            }
        }
    }

    _refreshAuthentication(webServiceEnt) {
        apiKey := webServiceEnt["Provider"]["AppKey"]
        refreshToken := webServiceEnt.AuthData["refresh_token"]
        refreshUrl := webServiceEnt["Provider"].GetAuthenticationRefreshUrl(Map("key", apiKey))
        response := ""

        if (!apiKey) {
            throw OperationFailedException("Missing API key for auth refresh.")
        }

        if (!refreshToken) {
            throw OperationFailedException("Missing refresh token for auth refresh.")
        }

        if (refreshUrl) {
            payload := Map(
                "grant_type", "refresh_token",
                "refresh_token", refreshToken
            )

            response := webServiceEnt.Request(refreshUrl, "POST", payload, false, false).Send()
        }

        success := response.IsSuccessful()

        if (response && success) {
            this._extractAuthData(webServiceEnt, response)
        } else {
            url := response.httpReqObj.url.ToString(true)
            webServiceEnt.SetAuthData("refresh_token", "", true)

            ; @todo handle common http error codes
        }

        return success
    }
}
