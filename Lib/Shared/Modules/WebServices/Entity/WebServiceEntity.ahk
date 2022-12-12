class WebServiceEntity extends AppEntityBase {
    cacheObj := ""
    stateObj := ""
    persistentStateObj := ""
    mergeDataFromApi := false

    Authenticated {
        get => this.IsAuthenticated()
    }

    UserId {
        get => this.AuthData["user_id"]
    }

    AuthData[key] {
        get => this.GetAuthData(key, true)
        set => this.SetAuthData(key, value)
    }

    __New(app, id, entityTypeId, container, cacheObj, stateObj, persistentStateObj, eventMgr, storageObj, idSanitizer, parentEntity := "") {
        this.cacheObj := cacheObj
        this.stateObj := stateObj
        this.persistentStateObj := persistentStateObj

        super.__New(app, id, entityTypeId, container, eventMgr, storageObj, idSanitizer, parentEntity)
    }

    static Create(container, eventMgr, id, entityTypeId, storageObj, idSanitizer, parentEntity := "") {
        className := this.Prototype.__Class

        return %className%(
            container.GetApp(),
            id,
            entityTypeId,
            container,
            container.Get("cache.web_services"),
            container.Get("state.web_services_tmp"),
            container.Get("state.web_services"),
            eventMgr,
            storageObj,
            idSanitizer,
            parentEntity
        )
    }

    BaseFieldDefinitions() {
        definitions := super.BaseFieldDefinitions()

        if (this.idVal == "api" && definitions.Has("name")) {
            definitions["name"]["editable"] := false
        }

        definitions["Provider"] := Map(
            "type", "entity_reference",
            "entityType", "web_service_provider",
            "required", true,
            "editable", false
        )

        definitions["AutoLogin"] := Map(
            "type", "boolean",
            "description", "Automatically authenticate with this service when Launchpad starts.",
            "required", false,
            "default", (this.idVal == "api")
        )

        definitions["Enabled"] := Map(
            "type", "boolean",
            "required", false,
            "default", true
        )

        return definitions
    }

    IsAuthenticated() {
        isAuthenticated := false

        if (this["Provider"]["SupportsAuthentication"]) {
            isAuthenticated := this["Provider"]["Authenticator"].IsAuthenticated(this)
        }

        return isAuthenticated
    }

    Login() {
        if (this["Provider"]["SupportsAuthentication"]) {
            this["Provider"]["Authenticator"].Login(this)
        }
    }

    Logout() {
        if (this["Provider"]["SupportsAuthentication"]) {
            this["Provider"]["Authenticator"].Logout(this)
        }
    }

    Request(path, method := "", data := "", useAuthentication := -1, cacheResponse := true) {
        if (!method) {
            method := this["Provider"]["DefaultMethod"]
        }

        if (useAuthentication == -1) {
            useAuthentication := this["Provider"]["AuthenticateRequestsByDefault"]
        }

        return BasicWebServiceRequest(this.eventMgr, this, this.cacheObj, method, path, data, useAuthentication, cacheResponse)
    }

    GetAuthData(key := "", includePersistent := true) {
        val := this._getStateData(this.stateObj, key)

        if (!val && includePersistent) {
            val := this._getStateData(this.persistentStateObj, key)
        }

        return val
    }

    SetAuthData(keyOrMap, value, persist := false) {
        result := this._setStateData(this.stateObj, keyOrMap, value)

        if (persist) {
            this._setStateData(this.persistentStateObj, keyOrMap, value)
        }

        return this
    }

    ResetAuthData(newData := "", persist := false) {
        if (!newData) {
            newData := Map()
        }

        if (!newData.Has("authenticated")) {
            newData["authenticated"] := false
        }

        this._createStateParents(this.stateObj)
        this.stateObj.State["WebServices"][this.Id]["AuthData"] := newData
        this.stateObj.SaveState()

        if (persist) {
            this._createStateParents(this.persistentStateObj)
            this.persistentStateObj.State["WebServices"][this.Id]["AuthData"] := Map(
                "authenticated", newData["authenticated"]
            )
        }

        return this
    }

    DeleteAuthData(key, persist := false) {
        this._deleteStateData(this.stateObj, key)

        if (persist) {
            this._deleteStateData(this.persistentStateObj, key)
        }

        return this
    }

    _getStateData(stateObj, key := "") {
        save := this._createStateParents(stateObj)

        if (save) {
            stateObj.SaveState()
        }

        authData := stateObj.State["WebServices"][this.Id]["AuthData"]

        if (key) {
            authData := (authData.Has(key) ? authData[key] : "")
        }

        return authData
    }

    _setStateData(stateObj, key, value) {
        this._createStateParents(stateObj)
        stateObj.State["WebServices"][this.Id]["AuthData"][key] := value
        stateObj.SaveState()

        return this
    }

    _deleteStateData(stateObj, key) {
        created := this._createStateParents(stateObj)
        save := created
        
        if (!created) {
            parent := this._getStateData(stateObj)

            if (HasBase(parent, Map.Prototype) && parent.Has(key)) {
                parent.Delete(key)
                save := true
            }
        }

        if (save) {
            stateObj.SaveState()
        }

        return this
    }

    _createStateParents(stateObj) {
        modified := false

        if (!stateObj.State.Has("WebServices")) {
            stateObj.State["WebServices"] := Map()
            modified := true
        }

        if (!stateObj.State["WebServices"].Has(this.Id)) {
            stateObj.State["WebServices"][this.Id] := Map()
            modified := true
        }

        if (!stateObj.State["WebServices"][this.Id].Has("AuthData")) {
            stateObj.State["WebServices"][this.Id]["AuthData"] := Map()
            modified := true
        }

        return modified
    }

    GetStatusInfo() {
        ; @todo fix this data
        statusText := "Not logged in"
        imgPath := ""
        email := ""

        if (this.Authenticated) {
            playerName := this.app.Config["player_name"]
            email := this.AuthData["email"]
            
            if (playerName) {
                statusText := playerName
            } else if (email) {
                statusText := email
            } else {
                statusText := "Logged in"
            }

            imgPath := this.AuthData["photo"]

            if (SubStr(imgPath, 1, 4) == "http") {
                cachePath := "account--profile.jpg"
                imgPath := this.app.Service("manager.cache")["file"].GetCachedDownload(cachePath, imgPath)
            }
        }

        return Map("name", statusText, "email", email, "photo", imgPath)
    }
}
