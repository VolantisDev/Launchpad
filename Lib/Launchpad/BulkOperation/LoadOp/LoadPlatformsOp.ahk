class LoadPlatformsOp extends BulkOperationBase {
    useProgress := false
    platformsConfigObj := ""
    progressTitle := "Loading Platforms"
    progressText := "Please wait while your platforms are processed..."
    successMessage := "Loaded {n} platform(s) successfully."
    failedMessage := "{n} platform(s) could not be loaded due to errors."

    __New(app, platformsConfigObj := "", owner := "") {
        if (platformsConfigObj == "") {
            platformsConfigObj := app.Service("manager.platform").GetConfig()
        }

        InvalidParameterException.CheckTypes("LoadPlatformsOp", "platformsConfigObj", platformsConfigObj, "PlatformsConfig")
        this.platformsConfigObj := platformsConfigObj
        super.__New(app, owner)
    }

    RunAction() {
        this.platformsConfigObj.LoadConfig()

        platforms := Map(
            "Basic", "BasicPlatform",
            "Bethesda", "BethesdaPlatform",
            "Epic", "EpicPlatform",
            "Origin", "OriginPlatform",
            "Riot", "RiotPlatform",
            "Steam", "SteamPlatform"
        )

        event := DefineComponentsEvent(LaunchpadEvents.PLATFORMS_DEFINE, platforms)
        this.app.Service("manager.event").DispatchEvent(LaunchpadEvents.PLATFORMS_DEFINE, event)
        platforms := event.components

        if (this.useProgress) {
            this.progress.SetRange(0, platforms.Count)
        }

        factory := this.app.Service("EntityFactory")

        for key, platformClass in platforms {
            this.StartItem(key, key)

            if (!this.platformsConfigObj.Has(key)) {
                this.platformsConfigObj[key] := Map()
            }

            platformConfig := this.platformsConfigObj[key]
            platformConfig["PlatformClass"] := platformClass
            requiredKeys := ""
            this.results[key] := factory.CreateEntity("PlatformEntity", key, platformConfig, "", requiredKeys)
            this.FinishItem(key, true, key . ": Loaded successfully.")
        }
    }
}
