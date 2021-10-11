class PlatformManager extends EntityManagerBase {
    _registerEvent := LaunchpadEvents.PLATFORMS_REGISTER
    _alterEvent := LaunchpadEvents.PLATFORMS_ALTER

    GetLoadOperation() {
        return LoadPlatformsOp(this.app, this.configObj)
    }

    GetDefaultConfigPath() {
        return this.app.Config["platforms_file"]
    }

    RemoveEntityFromConfig(key) {
        this.configObj["platforms"].Delete(key)
    }

    AddEntityToConfig(key, entityObj) {
        this.configObj["platforms"][key] := entityObj.UnmergedConfig
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
        op := DetectGamesOp(this.app, platforms)
        op.Run()

        allDetectedGames := Map()

        for key, detectedGames in op.GetResults() {
            for index, detectedGameObj in detectedGames {
                allDetectedGames[detectedGameObj.key] := detectedGameObj
            }
        }

        this.app.Service("GuiManager").OpenWindow("DetectedGamesWindow", allDetectedGames)
    }
}
