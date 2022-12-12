class JwtWebServiceAuthenticator extends WebServiceAuthenticatorBase {
    Login(webServiceEnt, retryCount := 0) {
        if (retryCount > this.maxRetries) {
            throw OperationFailedException("Login failed after " . retryCount . " tries.")
        }

        if (!this._hasRefreshToken(webServiceEnt)) {
            this._reauthenticate(webServiceEnt)
        }

        success := this._hasRefreshToken(webServiceEnt)
            ? this._refreshAuthentication(webServiceEnt)
            : false

        if (!success) {
            success := this.Login(webServiceEnt, retryCount + 1)
        }

        return success
    }

    Logout(webServiceEnt) {
        webServiceEnt.PersistentAuthData["auth_token"] := ""
        webServiceEnt.PersistentAuthData["refresh_token"] := ""
        webServiceEnt.ResetAuthData(Map("authenticated", false))

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
        return !!(webServiceEnt.PersistentAuthData["refresh_token"])
    }

    _reauthenticate(webServiceEnt) {
        refreshToken := this._authenticationGui(webServiceEnt)

        if (refreshToken) {
            this._setRefreshToken(webServiceEnt, refreshToken)
        }

        return refreshToken
    }

    _getRefreshToken(webServiceEnt) {
        return webServiceEnt.PersistentAuthData["refresh_token"]
    }

    _setRefreshToken(webServiceEnt, refreshToken) {
        webServiceEnt.PersistentAuthData["refresh_token"] := refreshToken
    }

    _extractAuthData(webServiceEnt, response) {
        loginData := response.GetJsonData()
        authData := Map(
            "authenticated", (loginData.Has("user_id") && !!(loginData["user_id"]))
        )
        persistentData := Map()
        authDataMap := Map()
        persistentDataMap := Map(
            "user_id", "user_id",
            "refresh_token", "refresh_token",
            "id_token", "auth_token",
            "access_token", "access_token"
        )
        skipKeys := [
            "expires_in"
        ]

        if (loginData.Has("expires_in")) {
            persistentData["expires"] := DateAdd(A_Now, loginData["expires_in"], "S")
        }

        for key, val in loginData {
            if (persistentDataMap.Has(key)) {
                persistentData[persistentDataMap[key]] := loginData[key]
            } else if (authDataMap.Has(key)) {
                authData[authDataMap[key]] := loginData[key]
            } else if (!authData.Has(key) && !persistentData.Has(key)) {
                skip := false

                for index, skipKey in skipKeys {
                    if (key == skipKey) {
                        skip := true
                        break
                    }
                }

                if (!skip) {
                    authData[key] := val
                }
            }
        }

        for key, val in authData {
            webServiceEnt.AuthData[key] := val
        }

        for key, val in persistentData {
            webServiceEnt.PersistentAuthData[key] := val
        }
    }

    _refreshAuthentication(webServiceEnt) {
        apiKey := webServiceEnt["Provider"]["AppKey"]
        refreshToken := webServiceEnt.PersistentAuthData["refresh_token"]
        refreshUrl := webServiceEnt["Provider"].GetAuthenticationRefreshUrl(Map("token", apiKey))
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
            webServiceEnt.PersistentAuthData["refresh_token"] := ""
        }

        return success
    }
}
