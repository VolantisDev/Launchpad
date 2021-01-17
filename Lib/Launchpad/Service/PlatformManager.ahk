class PlatformManager extends AppComponentServiceBase {
    _registerEvent := LaunchpadEvents.LAUNCHERS_REGISTER
    _alterEvent := LaunchpadEvents.LAUNCHERS_ALTER
    platformsConfigObj := ""

    Platforms[] {
        get => this._components
        set => this._components := value
    }

    __New(app, platformsFile := "") {
        this.platformsConfigObj := PlatformsConfig.new(app, platformsFile, false)
        super.__New(app, "", false)
    }

    LoadComponents(platformsFile := "") {
        this._componentsLoaded := false

        if (platformsFile != "") {
            this.platformsConfigObj.ConfigPath := platformsFile
        }

        if (this.platformsConfigObj.ConfigPath == "") {
            this.platformsConfigObj.ConfigPath := this.app.Config.PlatformsFile
        }

        operation := LoadPlatformsOp.new(this.app, this.platformsConfigObj)
        success := operation.Run()
        this._components := operation.GetResults()
        super.LoadComponents()

        return success
    }

    GetPlatformsConfig() {
        return this.platformsConfigObj
    }

    CountPlatforms() {
        return this.Platforms.Count
    }

    SaveModifiedPlatforms() {
        this.platformsConfigObj.SaveConfig()
    }

    RemovePlatform(key) {
        if (this.Platforms.Has(key)) {
            this.Platforms.Delete(key)
            this.platformsConfigObj.Platforms.Delete(key)
        }
    }

    AddPlatform(key, platform) {
        this.Platforms[key] := platform
        this.platformsConfigObj.Games[key] := platform.UnmergedConfig 
        ; @todo should this use configObj instead of UnmergedConfig (which is a clone)?
    }

    GetActivePlatforms() {
        platforms := Map()

        if (!this._componentsLoaded) {
            this.LoadComponents()
        }

        for key, platform in this.Platforms {
            if (platform.IsEnabled && platform.IsInstalled) {
                platforms[key] := platform
            }
        }

        return platforms
    }
    
    DetectGames() {
        platforms := this.GetActivePlatforms()
        op := DetectGamesOp.new(this.app, platforms)
        op.Run()

        allDetectedGames := Map()

        for key, detectedGames in op.GetResults() {
            for index, detectedGameObj in detectedGames {
                allDetectedGames[detectedGameObj.key] := detectedGameObj
            }
        }

        this.app.Windows.DetectedGamesWindow(allDetectedGames)
    }
}
