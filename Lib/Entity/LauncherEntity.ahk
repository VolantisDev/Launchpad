class LauncherEntity extends EntityBase {
    managedLauncherObj := ""
    managedGameObj := ""

    /**
    * Entity references
    */

    ManagedLauncher {
        get => this.managedLauncherObj
        set => this.managedLauncherObj := value
    }

    ManagedGame {
        get => this.managedGameObj
        set => this.managedGameObj := value
    }

    /**
    * LAUNCHER SETTINGS
    */

    ; The directory where the entity build artifact(s) will be saved.
    DestinationDir {
        get => this.GetConfigValue("DestinationDir", false)
        set => this.SetConfigValue("DestinationDir", value, false)
    }

    ; The icon file that the launcher will use. This can be one of several types of values:
    ; - The filename of an existing icon in the AssetsDir
    ; - The path of another icon file on the system, which will be copied to the AssetsDir if it doesn't already exist
    ; - The path of an .exe file on the system where the icon will be extracted from and saved to the assets directory if it doesn't already exist
    ; - "" (empty string) - Auto detection. See below.
    ; 
    ; Auto detection rules if IconSrc is not set:
    ; 1. Look for [Key].ico in the assets directory
    ; 2. If GameExe is an absolute path, use GameExe's path as the IconSrc
    ; 3. If GameExe is a filename, search for that filename in GameDirs and use its path as the IconSrc if found
    ; 3. Prompt for an icon during validation if the path is still not set
    IconSrc {
        get => this.GetConfigValue("IconSrc", false)
        set => this.SetConfigValue("IconSrc", value, false)
    }

    __New(app, key, config, requiredConfigKeys := "", defaultDataSource := "") {
        ; @todo instantiate managedLauncherObj and managedGameObj here?

        this.ManagedLauncher := ManagedLauncherEntity.new(app, key, config, "", defaultDataSource)
        this.ManagedGame := ManagedGameEntity.new(app, key, config, "", defaultDataSource)

        super.__New(app, key, config, requiredConfigKeys, defaultDataSource)
    }

    StoreOriginal(update := false) {
        originalObj := super.StoreOriginal(update)
        originalObj.managedLauncherObj := this.managedLauncherObj.StoreOriginal()
        originalObj.managedGameObj := this.managedGameObj.StoreOriginal()
        return this.originalObj
    }

    GetDefaultDestinationDir() {
        defaultDir := this.app.Config.DestinationDir

        if (this.app.Config.CreateIndividualDirs) {
            defaultDir .= "\" . this.Key
        }

        return defaultDir
    }

    InitializeRequiredConfigKeys(requiredConfigKeys := "") {
        super.InitializeRequiredConfigKeys(requiredConfigKeys)
        this.AddRequiredConfigKeys(["LauncherType", "LauncherClass", "GameType", "GameClass"])
    }

    Validate() {
        validateResult := super.Validate()

        if (this.IconSrc == "" and !this.IconFileExists()) {
            validateResult["success"] := false
            validateREsult["invalidFields"].push("IconSrc")
        }

        ; @todo more launcher validation

        return ValidateResult
    }

    IconFileExists() {
        iconSrc := this.IconSrc != "" ? this.IconSrc : this.GetAssetPath(this.Key . ".ico")
        return FileExist(iconSrc)
    }

    LaunchEditWindow(mode, owner) {
        return this.app.Windows.LauncherEditor(this, mode, owner)
    }

    RestoreFromOriginal() {
        super.RestoreFromOriginal()
        this.ManagedLauncher.RestoreFromOriginal()
        this.ManagedGame.RestoreFromOriginal()
    }

    SaveModifiedData() {
        this.UnmergedConfig := this.MergeFromObject(this.UnmergedConfig, this.ManagedLauncher.GetModifiedData(), true)
        this.UnmergedConfig := this.MergeFromObject(this.UnmergedConfig, this.ManagedGame.GetModifiedData(), true)
        return super.SaveModifiedData()
    }

    MergeDefaultsIntoConfig(config) {
        defaults := super.MergeDefaultsIntoConfig(config)
        dataSources := this.GetAllDataSources()
        gameData := Map()

        gameData := this.AggregateGameData(dataSources)
        defaults := this.MergeFromObject(defaults, gameData["Defaults"], true)
        launcherType := this.DetectLauncherType(defaults, config)
        defaults["LauncherType"] := launcherType

        if (!defaults.Has("LauncherClass")) {
            defaults["LauncherClass"] := ""
        }

        if (gameData != "" and gameData.Has("Launchers")) {
            launcherType := this.DereferenceLauncherType(launcherType, gameData["Launchers"])

            if (gameData["Launchers"].Has(launcherType) and Type(gameData["Launchers"][launcherType]) == "Map") {
                defaults := this.MergeFromObject(defaults, gameData["Launchers"][launcherType], true)
            }
        }

        launcherTypeData := this.AggregateTypeData(launcherType, "Launchers", dataSources)
        defaults := this.MergeFromObject(defaults, launcherTypeData["Defaults"])


        ; Determine game type
        gameType := this.DetectGameType(defaults, config)
        defaults["gameType"] := gameType

        if (!defaults.Has("GameClass")) {
            defaults["GameClass"] := ""
        }

        ; Merge defaults from game type
        gameTypeData := this.AggregateTypeData(gameType, "Games", dataSources)
        defaults := this.MergeFromObject(defaults, gameTypeData["Defaults"])

        return defaults
    }

    GetAllDatasources() {
        dataSources := Map()

        if (this.DataSourceKeys != "") {
            dataSourceKeys := (Type(this.DataSourceKeys) == "Array") ? this.DataSourceKeys : [this.DataSourceKeys]

            for index, dataSourceKey in dataSourceKeys {
                dataSource := this.app.DataSources.GetDataSource(dataSourceKey)

                if (dataSource != "") {
                    dataSources[dataSourceKey] := dataSource
                }
            }
        }
        

        return dataSources
    }

    AggregateGameData(dataSources) {
        gameData := Map()
        defaults := Map()
        launchers := Map()

        for index, dataSource in dataSources {
            dsGameData := dataSource.ReadJson(this.Key, "Games")

            if (dsGameData != "") {
                if (dsGameData.Has("Defaults")) {
                    defaults := this.MergeFromObject(defaults, dsGameData["Defaults"])
                }

                if (dsGameData.Has("Launchers")) {
                    for launcherKey, launcherConfigObj in dsGameData.Has("Launchers") {
                        if (!launchers.Has(launcherKey)) {
                            launchers[launcherKey] := Map()
                        }

                        launchers[launcherKey] := this.MergeFromObject(launchers[launcherKey], dsGameData["Launchers"])
                    }
                }

                gameData := this.MergeFromObject(gameData, dsGameData)
            }
        }

        gameData["Defaults"] := defaults
        gameData["Launchers"] := launchers

        return gameData
    }

    AggregateTypeData(typeKey, typeName, dataSources) {
        typeData := Map()
        defaults := Map()

        for index, dataSource in dataSources {
            dsTypeData := dataSource.ReadJson(typeKey, "Types/" . typeName)

            if (dsTypeData != "") {
                 if (dsTypeData.Has("Defaults")) {
                    defaults := this.MergeFromObject(defaults, dsTypeData["Defaults"])
                }

                typeData := this.MergeFromObject(typeData, dsTypeData)
            }
        }

        typeData["Defaults"] := defaults

        return typeData
    }

    DetectLauncherType(defaults, config) {
        launcherType := ""

        if (config.Has("LauncherType")) {
            launcherType := config["LauncherType"]
        } else if (defaults.Has("LauncherType")) {
            launcherType := defaults["LauncherType"]
        }

        return (launcherType != "") ? launcherType : "Default"
    }

    DetectGameType(defaults, config) {
        gameType := ""

        if (config.Has("GameType")) {
            gameType := config["GameType"]
        } else if (defaults.Has("GameType")) {
            gameType := defaults["GameType"]
        }

        if (gameType == "") {
            gameType := "Default"
        }

        return gameType
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
        gameDir := checkSourceFile ? this.app.Config.AssetsDir : this.app.Config.DestinationDir

        if (checkSourceFile or this.app.Config.CreateIndividualDirs) {
            gameDir .= "\" . key
        }

        ext := checkSourceFile ? ".ahk" : ".exe"
        return gameDir . "\" . key . ext
    }

    AutoDetectValues() {
        
    }

    InitializeDefaults() {
        defaults := super.InitializeDefaults()
        defaults["DestinationDir"] := this.GetDefaultDestinationDir()
        defaults["IconSrc"] := ""
        return defaults
    }
}
