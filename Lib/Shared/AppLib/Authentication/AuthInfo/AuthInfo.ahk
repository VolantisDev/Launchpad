class AuthInfo {
    isAuthenticated := false
    secureData := Map()
    persistentData := Map()
    userIdField := "userId"

    Authenticated {
        get => this.isAuthenticated
        set => this.isAuthenticated := !!(value)
    }

    UserId {
        get => this.Get(this.userIdField)
    }

    Get(key) {
        value := ""

        if (this.secureData.Has(key)) {
            value := this.secureData[key]
        } else if (this.persistentData.Has(key)) {
            value := this.persistentData[key]
        }

        return value
    }

    Set(key, value, persist := false) {
        mapObj := persist ? this.persistentData : this.secureData
        mapObj[key] := value
    }

    GetPersistentData() {
        return this.persistentData
    }

    GetAhkTimestamp(unixTimestamp) {
        return DateAdd(19700101000000, unixTimestamp, "S")
    }
}
