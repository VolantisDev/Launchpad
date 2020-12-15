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
        get => this.DetectDestinationDir(this.GetIniValue("DestinationDir"))
        set => this.SetIniValue("DestinationDir", value)
    }

    LauncherFile {
        get => this.DetectLauncherFile(this.GetIniValue("LauncherFile"))
        set => this.SetIniValue("LauncherFile", value)
    }

    AssetsDir {
        get => this.DetectAssetsDir(this.GetIniValue("AssetsDir"))
        set => this.SetIniValue("AssetsDir", value)
    }

    ThemeName {
        get => this.GetIniValue("ThemeName") || "Lightpad"
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
        get => this.GetIniValue("ApiEndpoint") || "https://benmcclure.com/launcher-db"
        set => this.SetIniValue("ApiEndpoint", value)
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
        set => this.SetIniValue("RebuildExistingLaunchers", value)
    }

    CreateIndividualDirs {
        get => this.GetBooleanValue("CreateIndividualDirs", false)
        set => this.SetBooleanValue("CreateIndividualDirs", value)
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

    DetectDestinationDir(destinationDir := "") {
        if (destinationDir == "") {
            destinationDir := this.GetRawValue("DestinationDir")
        }

        if (destinationDir == "") {
            destinationDir := this.ChangeDestinationDir(destinationDir)
        }

        return destinationDir
    }

    ChangeDestinationDir(existingDir := "") {
        if (existingDir == "") {
            existingDir := this.GetRawValue("DestinationDir")
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

    DetectLauncherFile(launcherFile := "") {
        if (launcherFile == "") {
            launcherFile := this.GetRawValue("LauncherFile")
        }

        if (!launcherFile) {
            launcherFile := this.ChangeLauncherFile(launcherFile)
        }

        return launcherFile
    }

    ChangeLauncherFile(existingFile := "") {
        if (existingFile == "") {
            existingFile := this.GetRawValue("LauncherFile")
        }

        launcherFile := this.SelectLauncherFile(existingFile)

        if (launcherFile != "") {
            this.LauncherFile := launcherFile
        }

        return launcherFile
    }

    SelectLauncherFile(existingFile) {
        MsgBox("Launchpad uses a Launcher File to keep a list of games and settings for your launchers. The file is in JSON format and can be edited by hand or through the Launcher Manager in Launchpad.`n`nIf you have an existing Launcher File, select it on the following screen. If you want to create a new one, browse to the folder you would like and type in a new .json filename to use.", "Launchpad Launcher File", "OK")
        return FileSelect(3, existingFile, "Select the or create the Launcher File you would like Launchpad to use.", "JSON Documents (*.json)")
    }

    OpenAssetsDir() {
        Run(this.AssetsDir)
    }

    DetectAssetsDir(assetsDir := "") {
        if (assetsDir == "") {
            assetsDir := this.GetRawValue("AssetsDir")
        }

        if (!assetsDir) {
            assetsDir := this.ChangeAssetsDir(assetsDir)
        }

        return assetsDir
    }

    ChangeAssetsDir(existingDir := "") {
        if (existingDir == "") {
            existingDir := this.app.Config.GetRawValue("AssetsDir")
        }

        MsgBox("Launchpad both creates and uses other files when building and/or running your launchers. These files are known as Assets, and they are stored in a separate directory for each launcher you create.`n`nOn the following dialog, select the parent directory that Launchpad should create launcher assets within.", "Launchpad Assets Dir", "OK")
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
