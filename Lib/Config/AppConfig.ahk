class AppConfig extends IniConfig {
    appNameValue := ""
    defaultTempDir := ""
    defaultCacheDir := ""

    AppName[] {
        get {
            return this.appNameValue
        }
        set {
            return this.appNameValue := value
        }
    }

    LauncherDir[] {
        get {
            returnVal := this.GetIniValue("LauncherDir")

            if (this.LauncherManagerLoaded()) {
                returnVal := this.app.LauncherManager.DetectLauncherDir(returnVal)
            }
            
            return returnVal
        }
        set {
            return this.SetIniValue("LauncherDir", value)
        }
    }

    LauncherFile[] {
        get {
            returnVal := this.GetIniValue("LauncherFile")

            if (this.LauncherManagerLoaded()) {
                returnVal := this.app.LauncherManager.DetectLauncherFile(returnVal)
            }

            return returnVal
        }
        set {
            return this.SetIniValue("LauncherFile", value)
        }
    }

    AssetsDir[] {
        get {
            returnVal := this.GetIniValue("AssetsDir")

            if (this.LauncherManagerLoaded()) {
                returnVal := this.app.LauncherManager.DetectAssetsDir(returnVal)
            }

            return returnVal
        }
        set {
            return this.SetIniValue("AssetsDir", value)
        }
    }

    ApiEndpoint[] {
        get {
            return this.GetIniValue("ApiEndpoint") || "https://benmcclure.com/launcher-db"
        }
        set {
            return this.SetIniValue("ApiEndpoint", value)
        }
    }

    TempDir[] {
        get {
            return this.GetIniValue("TempDir") || this.defaultTempDir
        }
        set {
            return this.SetIniValue("TempDir", value)
        }
    }

    CacheDir[] {
        get {
            return this.GetIniValue("CacheDir") || this.TempDir . "\Cache"
        }
        set {
            return this.SetIniValue("CacheDir", value)
        }
    }

    UpdateExistingLaunchers[] {
        get {
            return this.GetBooleanValue("UpdateExistingLaunchers", true)
        }
        set {
            return this.SetIniValue("UpdateExistingLaunchers", value)
        }
    }

    IndividualDirs[] {
        get {
            return this.GetBooleanValue("IndividualDirs", false)
        }
        set {
            return this.SetBooleanValue("IndividualDirs", value)
        }
    }

    CopyAssets[] {
        get {
            return this.GetBooleanValue("CopyAssets", false)
        }
        set {
            return this.SetBooleanValue("CopyAssets", value)
        }
    }

    CleanLaunchersOnBuild[] {
        get {
            return this.GetBooleanValue("CleanLaunchersOnBuild", true)
        }
        set {
            return this.SetBooleanValue("CleanLaunchersOnBuild", value)
        }
    }

    CleanLaunchersOnExit[] {
        get {
            return this.GetBooleanValue("CleanLaunchersOnExit", false)
        }
        set {
            return this.SetBooleanValue("CleanLaunchersOnExit", value)
        }
    }

    FlushCacheOnExit[] {
        get {
            return this.GetBooleanValue("FlushCacheOnExit", false)
        }
        set {
            return this.SetBooleanValue("FlushCacheOnExit", value)
        }
    }

    __New(app, defaultTempDir) {
        this.defaultTempDir := defaultTempDir
        super.__New(app)
    }

    LauncherManagerLoaded() {
        return (this.app.LauncherManager != "")
    }

    GetBooleanValue(key, defaultValue) {
        returnVal := this.GetIniValue(key)

        if (returnVal == "") {
            returnVal := defaultValue
        }

        return returnVal
    }

    SetBooleanValue(key, booleanValue) {
        this.SetIniValue(key, !!(booleanValue))
    }

    GetRawValue(key) {
        return this.GetIniValue("ApiEndpoint")
    }
}
