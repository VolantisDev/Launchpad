class AppConfig extends IniConfig {
    appNameValue := ""
    defaultTempDir := ""
    defaultCacheDir := ""

    AppName[] {
        get => this.appNameValue
        set => this.appNameValue := value
    }

    LauncherDir[] {
        get {
            returnVal := this.GetIniValue("LauncherDir")
            return this.LaunchersLoaded() ? this.app.Launchers.DetectLauncherDir(returnVal) : returnVal
        }
        set => this.SetIniValue("LauncherDir", value)
    }

    LauncherFile[] {
        get {
            returnVal := this.GetIniValue("LauncherFile")
            return this.LaunchersLoaded() ? this.app.Launchers.DetectLauncherFile(returnVal) : returnVal
        }
        set => this.SetIniValue("LauncherFile", value)
    }

    AssetsDir[] {
        get {
            returnVal := this.GetIniValue("AssetsDir")
            return this.LaunchersLoaded() ? this.app.Launchers.DetectAssetsDir(returnVal) : returnVal
        }
        set => this.SetIniValue("AssetsDir", value)
    }

    DataSourceKey[] {
        get => this.GetIniValue("DataSourceKey") || "api"
        set => this.SetIniValue("DataSourceKey", value)
    }

    BuilderKey[] {
        get => this.GetIniValue("BuilderKey") || "ahk"
        set => this.SetIniValue("BuilderKey", value)
    }

    ApiEndpoint[] {
        get => this.GetIniValue("ApiEndpoint") || "https://benmcclure.com/launcher-db"
        set => this.SetIniValue("ApiEndpoint", value)
    }

    TempDir[] {
        get => this.GetIniValue("TempDir") || this.defaultTempDir
        set => this.SetIniValue("TempDir", value)
    }

    CacheDir[] {
        get => this.GetIniValue("CacheDir") || this.TempDir . "\Cache"
        set => this.SetIniValue("CacheDir", value)
    }

    UpdateExistingLaunchers[] {
        get => this.GetBooleanValue("UpdateExistingLaunchers", true)
        set => this.SetIniValue("UpdateExistingLaunchers", value)
    }

    IndividualDirs[] {
        get => this.GetBooleanValue("IndividualDirs", false)
        set => this.SetBooleanValue("IndividualDirs", value)
    }

    CopyAssets[] {
        get => this.GetBooleanValue("CopyAssets", false)
        set => this.SetBooleanValue("CopyAssets", value)
    }

    CleanLaunchersOnBuild[] {
        get => this.GetBooleanValue("CleanLaunchersOnBuild", true)
        set => this.SetBooleanValue("CleanLaunchersOnBuild", value)
    }

    RetainIconFilesOnClean[] {
        get => this.GetBooleanValue("RetainIconFilesOnClean", true)
        set => this.SetBooleanValue("RetainIconFilesOnClean", value)
    }

    CleanLaunchersOnExit[] {
        get => this.GetBooleanValue("CleanLaunchersOnExit", false)
        set => this.SetBooleanValue("CleanLaunchersOnExit", value)
    }

    FlushCacheOnExit[] {
        get => this.GetBooleanValue("FlushCacheOnExit", false)
        set => this.SetBooleanValue("FlushCacheOnExit", value)
    }

    __New(app, defaultTempDir) {
        this.defaultTempDir := defaultTempDir
        super.__New(app)
    }

    LaunchersLoaded() {
        return (this.app.Launchers != "")
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
        return this.GetIniValue(key)
    }
}
