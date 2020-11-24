class LauncherGame {
    app := ""
    keyVal := ""
    originalObj := ""
    configVal := Map()
    requiredConfigKeysVal := Array("gameType", "gameClass", "launcherType", "launcherClass")

    Key[] {
        get => this.keyVal
        set => this.keyVal := value
    }

    ; This retains a copy of the launcher game before any modifications were made during editing so that it can be compared later.
    ; This is populated prior to editing a launcher game, and deleted after the editing operation is completed.
    ; For example, if the key is changed, this will ensure the original item will be removed when the revised item is saved with a new key.
    Original[] {
        get => (this.originalObj != "") ? this.originalObj : this.StoreOriginal()
        set => this.originalObj := value
    }

    ; If the game key differs from the API key, the API key can be stored separately here. By default it is identical to the main key.
    ApiKey[] {
        get => this.configVal.Has("apiKey") ? this.configVal["apiKey"] : this.Key
        set => this.configVal["apiKey"] := value
    }

    DisplayName[] {
        get => this.configVal.Has("displayName") ? this.configVal["displayName"] : this.Key
        set => this.configVal["displayName"] := value
    }

    GameType[] {
        get => this.configVal.Has("gameType") ? this.configVal["gameType"] : "default"
        set => this.configVal["gameType"] := value
    }

    GameClass[] {
        get => this.configVal.Has("gameClass") ? this.configVal["gameClass"] : "ShortcutGame"
        set => this.configVal["gameClass"] := value
    }

    LauncherType[] {
        get => this.configVal.Has("launcherType") ? this.configVal["launcherType"] : "default"
        set => this.configVal["launcherType"] := value
    }

    LauncherClass[] {
        get => this.configVal.Has("launcherClass") ? this.configVal["launcherClass"] : "ThinLauncher"
        set => this.configVal["launcherClass"] := value
    }

    IconFile[] {
        get => this.configVal.Has("iconSrc") ? this.configVal["iconSrc"] : ""
        set => this.configVal["iconSrc"] := value
    }

    ShortcutFile[] {
        get => this.configVal.Has("shortcutSrc") ? this.configVal["shortcutSrc"] : ""
        set => this.configVal["shortcutSrc"] := value
    }

    RequiresShortcutFile[] {
        get => this.configVal.Has("requiresShortcutFile") ? this.configVal["requiresShortcutFile"] : true
        set => this.configVal["requiresShortcutFile"] := value
    }

    RunCmd[] {
        get => this.configVal.Has("runCmd") ? this.configVal["runCmd"] : ""
        set => this.configVal["runCmd"] := value
    }

    Config[] {
        get => this.configVal
        set => this.configVal := value
    }

    RequiredConfigKeys[] {
        get => this.requiredConfigKeysVal
        set => this.requiredConfigKeysVal := value
    }

    __New(app, key, config, requiredConfigKeys := "") {
        this.app := app
        this.keyVal := key

        if (requiredConfigKeys != "") {
            this.AddRequiredConfigKeys(requiredConfigKeys)
        }

        if (config != "") {
            this.configVal := config

            if (config.Has("requiredConfigKeys")) {
                this.AddRequiredConfigKeys(config["requiredConfigKeys"])
            }
        }
    }

    AddRequiredConfigKeys(configKeys) {
        for index, requiredKey in configKeys {
            if (!this.ConfigKeyIsRequired(requiredKey)) {
                this.requiredConfigKeysVal.push(requiredKey)
            }
        }
    }

    ConfigKeyIsRequired(configKey) {
        isRequired := false

        for index, requiredKey in this.requiredConfigKeysVal {
            if (configKey == requiredKey) {
                isRequired := true
                break
            }
        }

        return isRequired
    }

    Validate() {
        validateResult := Map("success", true, "invalidFields", Array())

        if (this.Key == "") {
            validateResult["success"] := false
            validateResult["invalidFields"].push("Key")
        }

        if (this.LauncherType == "") {
            validateResult["success"] := false
            validateResult["invalidFields"].push("LauncherType")
        }

        ; @todo more launcher type validation

        if (this.GameType == "") {
            validateResult["success"] := false
            validateResult["invalidFields"].push("GameType")
        }

        ; @ todo more game type validation

        if (this.IconFile == "" and !this.IconFileExists()) {
            validateResult["success"] := false
            validateREsult["invalidFields"].push("IconFile")
        }

        if (((this.RequiresShortcutFile or this.RunCmd == "") and this.ShortcutFile == "") and !this.ShortcutFileExists()) {
            validateResult["success"] := false
            validateResult["invalidFields"].push("ShortcutFile")
        }

        if (this.ShortcutFile == "" and this.RunCmd == "") {
            validateResult["success"] := false
            validateResult["invalidFields"].push("RunCmd")
        }

        return validateResult
    }

    Edit(launcherFileObj := "", mode := "config", owner := "MainWindow") {
        this.StoreOriginal()

        result := this.app.GuiManager.LauncherEditor(this, mode, owner)

        if (mode == "config" and launcherFileObj != "") {
            ; @todo save launcher data back to the provided launcher file object
        }

        return this.Validate()
    }

    IconFileExists() {
        iconSrc := this.IconFile != "" ? this.IconFile : this.GetAssetPath(this.Key . ".ico")
        return FileExist(iconSrc)
    }

    ShortcutFileExists() {
        shortcutSrc := this.ShortcutFile != "" ? this.ShortcutFile : this.GetAssetPath(this.Key . ".lnk")

        exists := FileExist(shortcutSrc)

        if (!exists) {
            shortcutSrc := this.GetAssetPath(this.Key . ".url")
            exists := FileExist(shortcutSrc)
        }

        return exists
    }

    GetAssetPath(path) {
        return this.app.AppConfig.AssetsDir . "\" . this.Key . "\" . path
    }

    StoreOriginal() {
        this.originalObj := this.Clone()
        this.originalObj.configVal := this.configVal.Clone()
        return this.originalObj
    }
}
