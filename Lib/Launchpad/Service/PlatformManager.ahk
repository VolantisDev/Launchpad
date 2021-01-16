class PlatformManager extends AppComponentServiceBase {
    platformsConfigObj := ""
    platformsLoaded := false

    Platforms[] {
        get => this._components
        set => this._components := value
    }

    __New(app, platformsFile := "") {
        this.platformsConfigObj := PlatformsConfig.new(app, platformsFile, false)
        super.__New(app)
    }

    LoadPlatforms(platformsFile := "") {
        if (platformsFile != "") {
            this.platformsConfigObj.ConfigPath := platformsFile
        }

        if (this.platformsConfigObj.ConfigPath == "") {
            this.platformsConfigObj.ConfigPath := this.app.Config.PlatformsFile
        }

        operation := LoadPlatformsOp.new(this.app, this.platformsConfigObj)
        success := operation.Run()
        this._components := operation.GetResults()
        this.platformsLoaded := true
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
        this.LoadPlatforms()
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

        if (!this.platformsLoaded) {
            this.LoadPlatforms()
        }

        for key, platform in this.Platforms {
            if (platform.IsEnabled and platform.IsInstalled) {
                platforms[key] := platform
            }
        }

        return platforms
    }
}
