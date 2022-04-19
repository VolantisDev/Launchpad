class LaunchpadConfig extends AppConfig {
    OpenDestinationDir() {
        Run(this.destination_dir)
    }

    ChangeDestinationDir(existingDir := "") {
        if (existingDir == "") {
            existingDir := this.destination_dir
        }

        destinationDir := this.SelectDestinationDir(existingDir)

        if (destinationDir != "") {
            this.destination_dir := destinationDir
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
        Run(this.launcher_file)
    }

    ChangeLauncherFile(existingFile := "") {
        if (existingFile == "") {
            existingFile := this.launcher_file
        }

        launcherFile := this.SelectLauncherFile(existingFile)

        if (launcherFile != "") {
            this.launcher_file := launcherFile
        }

        return launcherFile
    }

    SelectLauncherFile(existingFile) {
        MsgBox(this.app.appName . " uses a Launcher File to keep a list of games and settings for your launchers. The file is in JSON format and can be edited by hand or through the Launcher Manager in " . this.app.appName . ".`n`nIf you have an existing Launcher File, select it on the following screen. If you want to create a new one, browse to the folder you would like and type in a new .json filename to use.", this.app.appName . " Launcher File", "OK")
        path := FileSelect(8, existingFile, "Select or create the Launcher File you would like " . this.app.appName . " to use.", "JSON Documents (*.json)")

        if (path && !FileExist(path)) {
            FileAppend("{`"Games`": {}}", path)
        }

        return path
    }

    OpenBackupsFile() {
        Run(this.backups_file)
    }

    ChangeBackupsFile(existingFile := "") {
        if (existingFile == "") {
            existingFile := this.backups_file
        }

        backupsFile := this.SelectBackupsFile(existingFile)

        if (backupsFile != "") {
            this.backups_file := backupsFile
        }

        return backupsFile
    }

    SelectBackupsFile(existingFile) {
        MsgBox(this.app.appName . " uses a Backups File to keep a list of files to manage backups for. The file is in JSON format and can be edited by hand or through the Backup Manager in " . this.app.appName . ".`n`nIf you have an existing Backups File, select it on the following screen. If you want to create a new one, browse to the folder you would like and type in a new .json filename to use.", this.app.appName . " Backups File", "OK")
        path := FileSelect(8, existingFile, "Select or create the Backups File you would like " . this.app.appName . " to use.", "JSON Documents (*.json)")

        if (path && !FileExist(path)) {
            FileAppend("{`"Backups`": {}}", path)
        }

        return path
    }

    OpenPlatformsFile() {
        Run(this.platforms_file)
    }

    ChangePlatformsFile(existingFile := "") {
        if (existingFile == "") {
            existingFile := this.platforms_file
        }

        platformsFile := this.SelectPlatformsFile(existingFile)

        if (platformsFile != "") {
            this.platforms_file := platformsFile
        }

        return platformsFile
    }

    SelectPlatformsFile(existingFile) {
        MsgBox(this.app.appName . " uses a Platforms file to track a list of game platforms you have installed, and can use this for things such as detecting your installed games. This file is in JSON format, and can be edited by hand or through the Platform Manager in " . this.app.appName . ".`n`nIf you have an existing Platforms file, sleect it on the following screen. If you want to create a new one, browse to th efolder you would like and type in a new .json filename to use", this.app.appName . " Platforms File", "OK")
        path := FileSelect(8, existingFile, "Select or create the Platforms File you would like " . this.app.appName . " to use.", "JSON Documents (*.json)")

        if (path && !FileExist(path)) {
            FileAppend("{`"Platforms`": {}}", path)
        }

        return path
    }

    OpenAssetsDir() {
        Run(this.assets_dir)
    }

    ChangeAssetsDir(existingDir := "") {
        if (existingDir == "") {
            existingDir := this.assets_dir
        }

        MsgBox(this.app.appName . " sometimes creates and uses other files when building and/or running your launchers. These files are known as Assets, and they are stored in a separate directory for each launcher you create.`n`nOn the following dialog, select the parent directory that " . this.app.appName . " should create launcher assets within.", this.app.appName . " Assets Dir", "OK")
        assetsDir := this.SelectAssetsDir(existingDir)

        if (assetsDir != "") {
            this.app.Config["assets_dir"] := assetsDir
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
