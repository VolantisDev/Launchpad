class LaunchpadConfig extends AppConfig {
    DestinationDir {
        get => this.GetIniValue("DestinationDir") || this.app.dataDir . "\Launchers"
        set => this.SetIniValue("DestinationDir", value)
    }

    LauncherFile {
        get => this.GetIniValue("LauncherFile") || this.app.dataDir . "\Launchers.json"
        set => this.SetIniValue("LauncherFile", value)
    }

    PlatformsFile {
        get => this.GetIniValue("PlatformsFile") || this.app.dataDir . "\Platforms.json"
        set => this.SetIniValue("PlatformsFile", value)
    }

    AssetsDir {
        get => this.GetIniValue("AssetsDir") || this.app.dataDir . "\Launcher Assets"
        set => this.SetIniValue("AssetsDir", value)
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
        get => this.GetIniValue("ApiEndpoint") || "https://api.launchpad.games/v1"
        set => this.SetIniValue("ApiEndpoint", value)
    }

    ApiAuthentication {
        get => this.GetBooleanValue("ApiAuthentication", true)
        set => this.SetBooleanValue("ApiAuthentication", value)
    }

    ApiAutoLogin {
        get => this.GetBooleanValue("ApiAutoLogin", false)
        set => this.SetBooleanValue("ApiAutoLogin", value)
    }

    BackupDir {
        get => this.GetIniValue("BackupDir") || this.app.dataDir . "\Backups"
        set => this.SetIniValue("BackupDir", value)
    }

    BackupsFile {
        get => this.GetIniValue("BackupsFile") || this.app.dataDir . "\Backups.json"
        set => this.SetIniValue("BackupsFile", value)
    }

    BackupsToKeep {
        get => this.GetIniValue("BackupsToKeep") || 5
        set => this.SetIniValue("BackupsToKeep", value)
    }

    AutoBackupConfigFiles {
        get => this.GetBooleanValue("AutoBackupConfigFiles", true)
        set => this.SetBooleanValue("AutoBackupConfigFiles", value)
    }

    RebuildExistingLaunchers {
        get => this.GetBooleanValue("RebuildExistingLaunchers", true)
        set => this.SetBooleanValue("RebuildExistingLaunchers", value)
    }

    CreateDesktopShortcuts {
        get => this.GetBooleanValue("CreateDesktopShortcuts", false)
        set => this.SetBooleanValue("CreateDesktopShortcuts", value)
    }

    CleanLaunchersOnBuild {
        get => this.GetBooleanValue("CleanLaunchersOnBuild", false)
        set => this.SetBooleanValue("CleanLaunchersOnBuild", value)
    }

    RetainIconFilesOnClean {
        get => this.GetBooleanValue("RetainIconFilesOnClean", true)
        set => this.SetBooleanValue("RetainIconFilesOnClean", value)
    }

    CleanLaunchersOnExit {
        get => this.GetBooleanValue("CleanLaunchersOnExit", true)
        set => this.SetBooleanValue("CleanLaunchersOnExit", value)
    }

    CheckUpdatesOnStart {
        get => this.GetBooleanValue("CheckUpdatesOnStart", true)
        set => this.SetBooleanValue("CheckUpdatesOnStart", value)
    }

    UseAdvancedLauncherEditor {
        get => this.GetBooleanValue("UseAdvancedEditor", false)
        set => this.SetBooleanValue("UseAdvancedEditor", value)
    }

    LaunchersLoaded() {
        return (this.app.Launchers != "")
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
        MsgBox(this.app.appName . " creates .exe files for each of the launchers you define in your Launcher File.`n`nOn the following dialog, select the destination directory that " . this.app.appName . " should create your launchers within.", this.app.appName . " Destination Dir", "OK")

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
        MsgBox(this.app.appName . " uses a Launcher File to keep a list of games and settings for your launchers. The file is in JSON format and can be edited by hand or through the Launcher Manager in " . this.app.appName . ".`n`nIf you have an existing Launcher File, select it on the following screen. If you want to create a new one, browse to the folder you would like and type in a new .json filename to use.", this.app.appName . " Launcher File", "OK")
        path := FileSelect(8, existingFile, "Select or create the Launcher File you would like " . this.app.appName . " to use.", "JSON Documents (*.json)")

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
        MsgBox(this.app.appName . " uses a Platforms file to track a list of game platforms you have installed, and can use this for things such as detecting your installed games. This file is in JSON format, and can be edited by hand or through the Platform Manager in " . this.app.appName . ".`n`nIf you have an existing Platforms file, sleect it on the following screen. If you want to create a new one, browse to th efolder you would like and type in a new .json filename to use", this.app.appName . " Platforms File", "OK")
        path := FileSelect(8, existingFile, "Select or create the Platforms File you would like " . this.app.appName . " to use.", "JSON Documents (*.json)")

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

        MsgBox(this.app.appName . " sometimes creates and uses other files when building and/or running your launchers. These files are known as Assets, and they are stored in a separate directory for each launcher you create.`n`nOn the following dialog, select the parent directory that " . this.app.appName . " should create launcher assets within.", this.app.appName . " Assets Dir", "OK")
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
