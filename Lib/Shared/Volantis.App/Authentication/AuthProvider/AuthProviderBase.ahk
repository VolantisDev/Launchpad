class AuthProviderBase {
    __New(persistentData := "") {

    }

    Login() {

    }

    Logout(authInfoObj) {

    }

    NeedsRefresh(authInfoObj) {

    }

    RefreshAuthentication(authInfoObj) {

    }

    AddRefreshInfoToRequest(authInfoObj, httpReqObj) {
        ; Add refresh token to the request
    }

    AddLoginInfoToRequest(authToken, httpReqObj) {
        ; Add auth info needed to complete login to the request
    }

    AddAuthInfoToRequest(authInfoObj, httpReqObj) {
        ; Add auth info from authInfoObj to httpReqObj as needed
    }

    ExtractAuthInfoFromResponse(httpReqObj) {

    }
}
