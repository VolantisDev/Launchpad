class JwtAuthInfo extends AuthInfo {
    __New(userInfo) {
        super.__New()

        this.Authenticated := false

        added := Map()

        if (userInfo.Has("user_id")) {
            this.Authenticated := !!(userInfo["user_id"])
            this.Set("userId", userInfo["user_id"], true)
            added["user_id"] := true
        }

        if (userInfo.Has("refresh_token")) {
            this.Set("refresh", userInfo["refresh_token"], true)
            added["refresh_token"] := true
        }

        if (userInfo.Has("expires_in")) {
            timestamp := DateAdd(A_Now, userInfo["expires_in"], "S")
            this.Set("expires", timestamp, true)
            added["expires_in"] := true
        }

        if (userInfo.Has("id_token")) {
            this.Set("authToken", userInfo["id_token"])
            added["id_token"] := true
        }
        
        for (key, value in userInfo) {
            if (!added.Has(key) || !added[key]) {
                this.Set(key, value)
            }
        }
    }
}
