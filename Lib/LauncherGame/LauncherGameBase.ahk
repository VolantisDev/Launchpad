class LauncherGameBase {
    app := ""
    keyVal := ""
    dataSource := ""
    mergedConfigVal := Map()
    unmergedConfigVal := Map()
    gameDefaults := Map()
    requiredConfigKeysVal := Array("gameType", "gameClass", "launcherType", "launcherClass")

    ; The ID used to refer to the game, typically the game's name.
    Key[] {
        get => this.keyVal
        set => this.keyVal := value
    }

    ; Configuration that has been merged with defaults from external sources.
    ; This is the object that most of the other values in this class come from.
    Config[] {
        get => this.mergedConfigVal
        set => this.mergedConfigVal := value
    }

    ; The unmodified original configuration from the launcher file.
    ; When editing the launcher, this is where the raw updated configuration is stored.
    UnmergedConfig[] {
        get => this.unmergedConfigVal
        set => this.unmergedConfigVal := value
    }

    ; If the game key differs from the API key, the API key can be stored here.
    ; It defaults to the game key.
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

    RequiredConfigKeys[] {
        get => this.requiredConfigKeysVal
        set => this.requiredConfigKeysVal := value
    }

    __New(app, key, config, requiredConfigKeys := "", dataSource := "") {
        if (dataSource == "") {
            dataSource := this.app.Config.DataSourceKey
        }

        this.app := app
        this.keyVal := key
        this.dataSource := IsObject(dataSource) ? dataSource : app.DataSources.GetDataSource(dataSourceKey)

        this.SetGameDefaults()

        if (requiredConfigKeys != "") {
            this.AddRequiredConfigKeys(requiredConfigKeys)
        }

        if (config != "") {
            this.unmergedConfigVal := config
            this.configVal := config

            if (config.Has("requiredConfigKeys")) {
                this.AddRequiredConfigKeys(config["requiredConfigKeys"])
            }
        }
    }

    SetGameDefaults() {
        this.gameDefaults["requiresShortcutFile"] := false
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
        return this.app.Config.AssetsDir . "\" . this.Key . "\" . path
    }

    MergeDefaults(update := false) {
        if (!update and this.mergedConfigVal.Count > 0) {
            return this.Config
        }

        defaults := this.gameDefaults
        config := this.UnmergedConfig

        ; Set some initial defaults
        defaults["assetsDir"] := this.app.Config.AssetsDir . "\" . this.Key

        ; Attempt to load the game from the datasource
        gameData := this.dataSource.ReadJson(this.Key, "games")

        if (gameData != "") {
            if (gameData.Has("defaults")) {
                defaults := this.MergeDefaultItems(defaults, gameData["defaults"])
            }
        }

        ; Determine initial launcher type (possibly a reference to another launcher type)
        launcherType := ""
        if (config.Has("launcherType")) {
            launcherType := config["launcherType"]
        } else if (defaults.Has("launcherType")) {
            launcherType := defaults["launcherType"]
        }
        if (launcherType == "") {
            launcherType := "default"
        }
        defaults["launcherType"] := launcherType
        
        ; Make sure there is an empty string default for the launcher class.
        if (!defaults.Has("launcherClass")) {
            defaults["launcherClass"] := ""
        }

        ; Dereference and merge launcher defaults from the game data
        if (gameData != "" and gameData.Has("launchers")) {
            launcherType := this.DereferenceLauncherType(launcherType, gameData["launchers"])

            if (gameData["launchers"].Has(launcherType) and IsObject(gameData["launchers"][launcherType])) {
                defaults := this.MergeDefaultItems(gameData["launchers"][launcherType], defaults)
            }
        }

        ; Merge defaults from the launcher type
        launcherTypeData := this.dataSource.ReadJson(launcherType, "types/launchers")

        if (launcherTypeData != "") {
            defaults["launcherClass"] := launcherTypeData["class"]

            if (launcherTypeData.Has("defaults")) {
                defaults := this.MergeDefaultItems(launcherTypeData["defaults"], defaults)
            }
        }

        ; Determine game type
        gameType := ""
        if (config.Has("gameType")) {
            gameType := config["gameType"]
        } else if (defaults.Has("gameType")) {
            gameType := defaults["gameType"]
        }
        if (gameType == "") {
            gameType := "default"
        }
        defaults["gameType"] := gameType

        if (!defaults.Has("gameClass")) {
            defaults["gameClass"] := ""
        }

        ; Merge defaults from game type
        gameTypeData := this.dataSource.ReadJson(gameType, "types/games")

        if (gameTypeData != "") {
            defaults["gameClass"] := gameTypeData["class"]

            if (gameTypeData.Has("defaults")) {
                defaults := this.MergeDefaultItems(gameTypeData["defaults"], defaults)
            }
        }

        this.Config := defaults
        return defaults
    }

    MergeDefaultItems(object1, object2) {
        newObject := object1

        for key, value in object2
        {
            newObject[key] := value
        }

        return newObject
    }

    DereferenceLauncherType(launcherType, launchersConfig) {
        if (launchersConfig.Has(launcherType) && !IsObject(launchersConfig[launcherType])) {
            launcherType := this.DereferenceLauncherType(launchersConfig[launcherType], launchersConfig)
        }

        return launcherType
    }

    LauncherExists(checkSourceFile := false) {
        return (FileExist(this.GetLauncherFile(this.Key, checkSourceFile)) != "")
    }

    GetLauncherFile(key, checkSourceFile := false) {
        gameDir := checkSourceFile ? this.app.Config.AssetsDir : this.app.Config.LauncherDir

        if (checkSourceFile or this.app.Config.IndividualDirs) {
            gameDir .= "\" . key
        }

        ext := checkSourceFile ? ".ahk" : ".exe"
        return gameDir . "\" . key . ext
    }
}
