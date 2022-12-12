class WebServiceAuthenticatorBase {
    refreshThresholdSeconds := 600
    authenticatedStateKey := "authenticated"
    expiresStateKey := "expires"
    maxRetries := 3
    guiMgr := ""

    __New(guiMgr) {
        this.guiMgr := guiMgr
    }

    Login(webServiceEnt, retryCount := 0) {

    }

    Logout(webServiceEnt) {

    }

    RefreshAuthentication(webServiceEnt) {

    }

    AlterRequest(webServiceEnt, request, httpReqObj) {

    }

    IsAuthenticated(webServiceEnt) {
        auth := webServiceEnt.AuthData[this.authenticatedStateKey]
        expired := this.AuthenticationIsExpired(webServiceEnt)

        return auth && !expired

    }

    NeedsRefresh(webServiceEnt) {
        needsRefresh := false

        if (this.IsAuthenticated(webServiceEnt)) {
            expires := webServiceEnt.AuthData[this.expiresStateKey]

            if (expires) {
                diff := DateDiff(A_Now, expires, "S")
                needsRefresh := (diff >= (0 - this.refreshThresholdSeconds))
            } else {
                needsRefresh := true
            }
        } else {
            needsRefresh := true
        }

        return needsRefresh
    }

    AuthenticationIsExpired(webServiceEnt) {
        expired := true

        if (webServiceEnt.AuthData[this.authenticatedStateKey] && webServiceEnt.AuthData[this.expiresStateKey]) {
            expired := (DateDiff(A_Now, webServiceEnt.AuthData["expires"], "S") >= 0)
        }

        return expired
    }

    _authenticationGui(webServiceEnt) {
        loginWindowGui := webServiceEnt["Provider"]["LoginWindow"]
        result := ""

        if (loginWindowGui) {
            result := this.guiMgr.Dialog(Map("type", loginWindowGui))
        }

        return result
    }

    _handleLoginFailure(message) {
        this.guiMgr.Dialog(Map(
            "title", "Login Failure",
            "text", message,
            "buttons", "*&OK"
        ))
    }
}
