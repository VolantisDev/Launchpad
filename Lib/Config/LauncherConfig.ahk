class LauncherConfig extends JsonWithDefaultsConfig {
    primaryConfigKey := "Games"
    defaultReferenceKey := "launcherType"

    gameDefaults := Map()

    Games[] {
        get => (this.config["Games"] != "") ? this.config["Games"] : Map()
        set => this.config["Games"] := value
    }

    __New(app, configPath := "", autoLoad := true, autoMerge := true) {
        this.gameDefaults.requiresShortcutFile := false
        super.__New(app, configPath, autoLoad, autoMerge)
    }

    LoadDefaultItemFromSource(key, configItem) {
        defaults := this.gameDefaults

        ; Set some initial defaults
        defaults["assetsDir"] := this.app.AppConfig.AssetsDir . "\" . key
        
        apiGameInstance := ApiGame.new(this.app, key)

        if (apiGameInstance.Exists()) {
            apiGameData := apiGameInstance.Read()
            
            ; Merge defaults from API game data
            if (apiGameData.Has("defaults")) {
                defaults := this.MergeData(defaults, apiGameData["defaults"])
            }

            launcherType := "default"
            if (configItem.Has("launcherType")) {
                launcherType := configItem["launcherType"]
            } else if (defaults.Has("launcherType")) {
                launcherType := defaults["launcherType"]
            }
            defaults["launcherType"] := launcherType
            
            if (!defaults.Has("launcherClass")) {
                defaults["launcherClass"] := ""
            }

            ; Dereference launcher type and merge defaults from game launcher data
            if (apiGameData.Has("launchers")) {
                launcherType := this.DereferenceLauncherType(launcherType, apiGameData["launchers"])

                if (apiGameData["launchers"].Has(launcherType) and IsObject(apiGameData["launchers"][launcherType])) {
                    defaults := this.MergeData(apiGameData["launchers"][launcherType], defaults)
                }
            }

            ; Merge defaults from launcher type
            apiLauncherTypeInstance := ApiLauncherType.new(this.app, launcherType)

            if (apilauncherTypeInstance.Exists()) {
                apiLauncherTypeData := apiLauncherTypeInstance.Read()

                defaults["launcherClass"] := apiLauncherTypeData["class"]

                if (apiLauncherTypeData.Has("defaults")) {
                    defaults := this.MergeData(apiLauncherTypeData["defaults"], defaults)
                }
            }
            
            ; Determine game type
            gameType := "default"
            if (configItem.Has("gameType")) {
                gameType := configItem["gameType"]
            } else if (defaults.Has("gameType")) {
                gameType := defaults["gameType"]
            }
            defaults["gameType"] := gameType

            if (!defaults.Has("gameClass")) {
                defaults["gameClass"] := ""
            }

            ; Merge defaults from game type
            if (gameType != "") {
                apiGameTypeInstance := ApiGameType.new(this.app, gameType)
                
                if (apiGameTypeInstance.Exists()) {
                    apiGameTypeData := apiGameTypeInstance.Read()

                    defaults["gameClass"] := apiGameTypeData["class"]
                    
                    if (apiGameTypeData.Has("defaults")) {
                        defaults := this.MergeData(apiGameTypeData["defaults"], defaults)
                    }
                }
            }
        }

        return defaults
    }

    DereferenceLauncherType(launcherType, launchersConfig) {
        if (launchersConfig.Has(launcherType) && !IsObject(launchersConfig[launcherType])) {
            launcherType := this.DereferenceLauncherType(launchersConfig[launcherType], launchersConfig)
        }

        return launcherType
    }
}
