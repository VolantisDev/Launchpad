class WebServiceEntity extends AppEntityBase {
    cacheObj := ""
    stateObj := ""
    persistentStateObj := ""
    mergeDataFromApi := false

    Authenticated {
        get => this.IsAuthenticated()
    }

    AuthData[key] {
        get => this.GetAuthData(key)
        set => this.SetAuthData(key, value)
    }

    PersistentAuthData[key] {
        get => this.GetPersistentAuthData(key)
        set => this.SetPersistentAuthData(key, value)
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

        return definitions
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

    GetAuthData(key := "") {
        return this._getStateData(this.stateObj, key)
    }

    SetAuthData(keyOrMap, value) {
        return this._setStateData(this.stateObj, keyOrMap, value)
    }

    ResetAuthData(newData := "") {
        if (!newData) {
            newData := Map()
        }

        this._createStateParents(this.stateObj)
        this.stateObj.State["WebServices"][this.Id]["AuthData"] := newData
        this.stateObj.SaveState()
    }

    GetPersistentAuthData(key := "") {
        return this._getStateData(this.persistentStateObj, key)
    }

    SetPersistentAuthData(key, value) {
        return this._setStateData(this.persistentStateObj, key, value)
    }

    _getStateData(stateObj, key) {
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
}
