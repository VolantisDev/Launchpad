class PlatformManager extends EntityManagerBase {
    _registerEvent := LaunchpadEvents.PLATFORMS_REGISTER
    _alterEvent := LaunchpadEvents.PLATFORMS_ALTER

    GetLoadOperation() {
        return LoadPlatformsOp.new(this.app, this.configObj)
    }

    CreateConfigObj(app, configFile) {
        return PlatformsConfig.new(app, configFile, false)
    }

    GetDefaultConfigPath() {
        return this.app.Config.PlatformsFile
    }

    RemoveEntityFromConfig(key) {
        this.configObj.Platforms.Delete(key)
    }

    AddEntityToConfig(key, entityObj) {
        this.configObj.Platforms[key] := entityObj.UnmergedConfig
    }

    GetActivePlatforms() {
        platforms := Map()

        if (!this._componentsLoaded) {
            this.LoadComponents()
        }

        for key, platform in this.Entities {
            if (platform.IsEnabled && platform.IsInstalled) {
                platforms[key] := platform
            }
        }

        return platforms
    }

    GetGameDetectionPlatforms() {
        platforms := Map()

        if (!this._componentsLoaded) {
            this.LoadComponents()
        }

        for key, platform in this.Entities {
            if (platform.IsEnabled && platform.IsInstalled && platform.DetectGames) {
                platforms[key] := platform
            }
        }

        return platforms
    }
    
    DetectGames() {
        platforms := this.GetGameDetectionPlatforms()
        op := DetectGamesOp.new(this.app, platforms)
        op.Run()

        allDetectedGames := Map()

        for key, detectedGames in op.GetResults() {
            for index, detectedGameObj in detectedGames {
                allDetectedGames[detectedGameObj.key] := detectedGameObj
            }
        }

        this.app.Service("GuiManager").OpenWindow("DetectedGamesWindow", "", allDetectedGames)
    }
}
