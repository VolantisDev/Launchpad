class AppConfig extends IniConfig {
    appNameValue := ""
    defaultTempDir := ""
    defaultAppDataDir := ""
    defaultCacheDir := ""

    AppName {
        get => this.appNameValue
        set => this.appNameValue := value
    }

    DestinationDir {
        get => this.GetIniValue("DestinationDir") || this.AppDataDir . "\Launchers"
        set => this.SetIniValue("DestinationDir", value)
    }

    LauncherFile {
        get => this.GetIniValue("LauncherFile") || this.AppDataDir . "\Launchers.json"
        set => this.SetIniValue("LauncherFile", value)
    }

    PlatformsFile {
        get => this.GetIniValue("PlatformsFile") || this.AppDataDir . "\Platforms.json"
        set => this.SetIniValue("PlatformsFile", value)
    }

    AssetsDir {
        get => this.GetIniValue("AssetsDir") || this.AppDataDir . "\Launcher Assets"
        set => this.SetIniValue("AssetsDir", value)
    }

    ThemeName {
        get => this.GetIniValue("ThemeName") || "Steampad"
        set => this.SetIniValue("ThemeName", value)
    }

    DataSourceKey {
        get => this.GetIniValue("DataSourceKey") || "api"
        set => this.SetIniValue("DataSourceKey", value)
    }

    BuilderKey {
        get => this.GetIniValue("BuilderKey") || "ahk"
        set => this.SetIniValue("BuilderKey", value)
    }

    ApiEndpoint {
        get => this.GetIniValue("ApiEndpoint") || "https://launchpad.games/api/v1"
        set => this.SetIniValue("ApiEndpoint", value)
    }

    ApiToken {
        get => this.GetIniValue("ApiToken") || ""
        set => this.SetIniValue("ApiToken", value)
    }

    TempDir {
        get => this.GetIniValue("TempDir") || this.defaultTempDir
        set => this.SetIniValue("TempDir", value)
    }

    AppDataDir {
        get => this.GetIniValue("AppDataDir") || this.defaultAppDataDir
        set => this.SetIniValue("AppDataDir", value)
    }

    CacheDir {
        get => this.GetIniValue("CacheDir") || this.TempDir . "\Cache"
        set => this.SetIniValue("CacheDir", value)
    }

    RebuildExistingLaunchers {
        get => this.GetBooleanValue("RebuildExistingLaunchers", true)
        set => this.SetBooleanValue("RebuildExistingLaunchers", value)
    }

    CreateIndividualDirs {
        get => this.GetBooleanValue("CreateIndividualDirs", false)
        set => this.SetBooleanValue("CreateIndividualDirs", value)
    }

    CreateDesktopShortcuts {
        get => this.GetBooleanValue("CreateDesktopShortcuts", false)
        set => this.SetBooleanValue("CreateDesktopShortcuts", value)
    }

    CopyAssets {
        get => this.GetBooleanValue("CopyAssets", false)
        set => this.SetBooleanValue("CopyAssets", value)
    }

    CleanLaunchersOnBuild {
        get => this.GetBooleanValue("CleanLaunchersOnBuild", true)
        set => this.SetBooleanValue("CleanLaunchersOnBuild", value)
    }

    RetainIconFilesOnClean {
        get => this.GetBooleanValue("RetainIconFilesOnClean", true)
        set => this.SetBooleanValue("RetainIconFilesOnClean", value)
    }

    CleanLaunchersOnExit {
        get => this.GetBooleanValue("CleanLaunchersOnExit", false)
        set => this.SetBooleanValue("CleanLaunchersOnExit", value)
    }

    FlushCacheOnExit {
        get => this.GetBooleanValue("FlushCacheOnExit", false)
        set => this.SetBooleanValue("FlushCacheOnExit", value)
    }

    LoggingLevel {
        get => this.GetIniValue("LoggingLevel") || "None"
        set => this.SetIniValue("LoggingLevel", value)
    }

    __New(app, defaultTempDir, defaultAppDataDir) {
        InvalidParameterException.CheckTypes("ValidateLaunchersOp", "defaultTempDir", defaultTempDir, "", "defaultAppDataDir", defaultAppDataDir, "")
        InvalidParameterException.CheckEmpty("ValidateLaunchersOp", "defaultTempDir", defaultTempDir, "defaultAppDataDir", defaultAppDataDir)
        this.defaultTempDir := defaultTempDir
        this.defaultAppDataDir := defaultAppDataDir
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

    OpenDestinationDir() {
        Run(this.DestinationDir)
    }

    ChangeDestinationDir(existingDir := "") {
        if (existingDir == "") {
            existingDir := this.DestinationDir
        }

        destinationDir := this.SelectDestinationDir(existingDir)

        if (destinationDir != "") {
            this.DestinationDir := destinationDir
        }

        return destinationDir
    }

    SelectDestinationDir(existingDir) {
        MsgBox("Launchpad creates .exe files for each of the launchers you define in your Launcher File.`n`nOn the following dialog, select the destination directory that Launchpad should create your launchers within.", "Launchpad Destination Dir", "OK")

        if (existingDir != "") {
            existingDir := "*" . existingDir
        }

        return DirSelect(existingDir, 3, "Create or select the folder to create game launchers within")
    }

    OpenLauncherFile() {
        Run(this.LauncherFile)
    }

    ChangeLauncherFile(existingFile := "") {
        if (existingFile == "") {
            existingFile := this.LauncherFile
        }

        launcherFile := this.SelectLauncherFile(existingFile)

        if (launcherFile != "") {
            this.LauncherFile := launcherFile
        }

        return launcherFile
    }

    SelectLauncherFile(existingFile) {
        MsgBox("Launchpad uses a Launcher File to keep a list of games and settings for your launchers. The file is in JSON format and can be edited by hand or through the Launcher Manager in Launchpad.`n`nIf you have an existing Launcher File, select it on the following screen. If you want to create a new one, browse to the folder you would like and type in a new .json filename to use.", "Launchpad Launcher File", "OK")
        path := FileSelect(8, existingFile, "Select or create the Launcher File you would like Launchpad to use.", "JSON Documents (*.json)")

        if (!FileExist(path)) {
            FileAppend("{`"Games`": {}}", path)
        }

        return path
    }

    OpenPlatformsFile() {
        Run(this.PlatformsFile)
    }

    ChangePlatformsFile(existingFile := "") {
        if (existingFile == "") {
            existingFile := this.PlatformsFile
        }

        platformsFile := this.SelectPlatformsFile(existingFile)

        if (platformsFile != "") {
            this.PlatformsFile := platformsFile
        }

        return platformsFile
    }

    SelectPlatformsFile(existingFile) {
        MsgBox("Launchpad uses a Platforms file to track a list of game platforms you have installed, and can use this for things such as detecting your installed games. This file is in JSON format, and can be edited by hand or through the Platform Manager in Launchpad.`n`nIf you have an existing Platforms file, sleect it on the following screen. If you want to create a new one, browse to th efolder you would like and type in a new .json filename to use", "Launchpad Platforms File", "OK")
        path := FileSelect(8, existingFile, "Select or create the Platforms File you would like Launchpad to use.", "JSON Documents (*.json)")

        if (!FileExist(path)) {
            FileAppend("{`"Platforms`": {}}", path)
        }

        return path
    }

    OpenAssetsDir() {
        Run(this.AssetsDir)
    }

    ChangeAssetsDir(existingDir := "") {
        if (existingDir == "") {
            existingDir := this.AssetsDir
        }

        MsgBox("Launchpad sometimes creates and uses other files when building and/or running your launchers. These files are known as Assets, and they are stored in a separate directory for each launcher you create.`n`nOn the following dialog, select the parent directory that Launchpad should create launcher assets within.", "Launchpad Assets Dir", "OK")
        assetsDir := this.SelectAssetsDir(existingDir)

        if (assetsDir != "") {
            this.app.Config.AssetsDir := assetsDir
        }

        return assetsDir
    }

    SelectAssetsDir(existingDir := "") {
        if (existingDir != "") {
            existingDir := "*" . existingDir
        }

        return DirSelect("*" . existingDir, 3, "Create or select the folder to create launcher assets within")
    }
}
