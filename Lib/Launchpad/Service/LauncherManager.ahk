class LauncherManager extends AppComponentServiceBase {
    launcherConfigObj := ""
    launchersLoaded := false

    Launchers[] {
        get => this._components
        set => this._components := value
    }

    __New(app, launcherFile := "") {
        this.launcherConfigObj := LauncherConfig.new(app, launcherFile, false)
        super.__New(app)
    }

    LoadLaunchers(launcherFile := "") {
        if (launcherFile == "") {
            launcherFile := this.app.Config.LauncherFile
        }

        if (!IsObject(launcherFile)) {
            launcherFile := LauncherConfig.new(this.app, launcherFile, false)
        }

        this.launchersConfigObj := launcherFile

        operation := LoadLaunchersOp.new(this.app, launcherFile)
        success := operation.Run()
        this._components := operation.GetResults()
        this.launchersLoaded := true
        return success
    }

    GetLauncherConfig() {
        return this.launcherConfigObj
    }

    CountLaunchers() {
        return this.Launchers.Count
    }

    DetectLauncherFile(launcherFile := "") {
        if (launcherFile == "") {
            launcherFile := this.app.Config.GetRawValue("LauncherFile")
        }
        
        if (!launcherFile) {
            launcherFile := this.ChangeLauncherFile()
        }

        return launcherFile
    }

    ChangeLauncherFile(launcherFile := "") {
        if (launcherFile == "") {
            launcherFile := this.app.Config.GetRawValue("LauncherFile")
        }

        launcherFile := this.SelectLauncherFile(launcherFile)

        if (launcherFile != "") {
            this.app.Config.LauncherFile := launcherFile
        }

        return launcherFile
    }

    SelectLauncherFile(existingFile := "") {
        MsgBox("Launchpad uses a Launcher File to keep a list of games and settings for your launchers. The file is in JSON format and can be edited by hand or through the Launcher Manager in Launchpad.`n`nIf you have an existing Launcher File, select it on the following screen. If you want to create a new one, browse to the folder you would like and type in a new .json filename to use.", "Launchpad Launcher File", "OK")
        return FileSelect(3, existingFile, "Select the or create the Launcher File you would like Launchpad to use.", "JSON Documents (*.json)")
        ; @todo Improve the UI of this selector
    }

    OpenLauncherFile() {
        Run(this.app.Config.LauncherFile)
    }

    DetectDestinationDir(launcherDir := "") {
        if (launcherDir == "") {
            launcherDir := this.app.Config.GetRawValue("DestinationDir")
        }

        if (!launcherDir) {
            launcherDir := this.ChangeDestinationDir()
        }

        return launcherDir
    }

    ChangeDestinationDir(launcherDir := "") {
        if (launcherDir == "") {
            launcherDir := this.app.Config.GetRawValue("DestinationDir")
        }

        launcherDir := this.SelectDestinationDir(launcherDir)

        if (launcherDir != "") {
            this.app.Config.DestinationDir := launcherDir
        }

        return launcherDir
    }

    SelectDestinationDir(existingDir := "") {
        MsgBox("Launchpad creates .exe files for each of the launchers you define in your Launcher File.`n`nOn the following dialog, select the destination directory that Launchpad should create your launchers within.", "Launchpad Destination Dir", "OK")
        
        if (existingDir != "") {
            existingDir := "*" . existingDir
        }

        return DirSelect(existingDir, 3, "Create or select the folder to create game launchers within")
    }

    OpenDestinationDir() {
        Run(this.app.Config.DestinationDir)
    }

    DetectAssetsDir(assetsDir := "") {
        if (assetsDir == "") {
            assetsDir := this.app.Config.GetRawValue("AssetsDir")
        }

        if (!assetsDir) {
            assetsDir := this.ChangeAssetsDir(assetsDir)
        }

        return assetsDir
    }

    ChangeAssetsDir(assetsDir := "") {
        MsgBox("Launchpad both creates and uses other files when building and/or running your launchers. These files are known as Assets, and they are stored in a separate directory for each launcher you create.`n`nOn the following dialog, select the parent directory that Launchpad should create launcher assets within.", "Launchpad Assets Dir", "OK")

        if (assetsDir == "") {
            assetsDir := this.app.Config.GetRawValue("AssetsDir")
        }

        assetsDir := this.SelectAssetsDir(assetsDir)

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

    OpenAssetsDir() {
        Run(this.app.Config.AssetsDir)
    }
}
