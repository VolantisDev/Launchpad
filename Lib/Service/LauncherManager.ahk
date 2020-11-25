class LauncherManager extends ServiceBase {
    launcherConfigObj := ""
    launchersMap := Map()
    dataSource := ""

    Launchers[] {
        get => this.launchersMap
        set => this.launchersMap := value
    }

    __New(app, launcherFile := "", dataSource := "") {
        this.launcherConfigObj := LauncherConfig.new(app, launcherFile, false)
        super.__New(app)
        this.SetDataSource(dataSource)
    }

     SetDataSource(dataSource) {
        if (dataSource == "") {
            dataSource := this.app.Config.DataSourceKey
        }

        this.dataSource := IsObject(dataSource) ? dataSource : this.app.DataSources.GetDataSource(dataSource)
    }

    LoadLaunchers(launcherFile := "") {
        if (launcherFile == "") {
            launcherFile := this.app.Config.LauncherFile
        }

        if (!IsObject(launcherFile)) {
            launcherFile := LauncherConfig.new(this.app, launcherFile, false)
        }

        this.launchersConfigObj := launcherFile

        operation := LoadLaunchersOp.new(this.app, launcherFile, this.dataSource)
        success := operation.Run()
        this.launchersMap := operation.GetResults()
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

    DetectLauncherDir(launcherDir := "") {
        if (launcherDir == "") {
            launcherDir := this.app.Config.GetRawValue("LauncherDir")
        }

        if (!launcherDir) {
            launcherDir := this.ChangeLauncherDir()
        }

        return launcherDir
    }

    ChangeLauncherDir(launcherDir := "") {
        if (launcherDir == "") {
            launcherDir := this.app.Config.GetRawValue("LauncherDir")
        }

        launcherDir := this.SelectLauncherDir(launcherDir)

        if (launcherDir != "") {
            this.app.Config.LauncherDir := launcherDir
        }

        return launcherDir
    }

    SelectLauncherDir(existingDir := "") {
        if (existingDir != "") {
            existingDir := "*" . existingDir
        }

        return DirSelect(existingDir, 3, "Create or select the folder to create game launchers within")
    }

    OpenLauncherDir() {
        Run(this.app.Config.LauncherDir)
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
