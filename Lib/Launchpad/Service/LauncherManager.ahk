class LauncherManager extends ServiceBase {
    launcherConfigObj := ""
    launcherEntities := Map()
    launchersLoaded := false

    Launchers[] {
        get => this.launcherEntities
        set => this.launcherEntities := value
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
        this.launcherEntities := operation.GetResults()
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
        return FileSelect(3, existingFile, "Select the Launchers file to use", "JSON Documents (*.json)")
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
