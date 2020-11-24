class LauncherManager extends ServiceBase {
    launcherConfigObj := ""
    builderObj := ""
    launchersMap := Map()
    dataSource := ""

    Launchers[] {
        get => this.launchersMap
        set => this.launchersMap := value
    }

    Builder[] {
        get => this.builderObj
        set => this.builderObj := value
    }

    __New(app, builderObj, launcherFile := "", dataSource := "") {
        this.launcherConfigObj := LauncherConfig.new(app, launcherFile, false)
        this.builderObj := builderObj

        if (dataSource == "") {
            dataSource := app.Config.DataSourceKey
        }

        this.dataSource := IsObject(dataSource) ? dataSource : app.DataSources.GetDataSource(dataSource)
        super.__New(app)
    }

    SetDataSource(dataSource) {
        this.dataSource := dataSource
    }

    LoadLaunchers(launcherFile := "") {
        progress := this.app.Windows.ProgressIndicator("Loading Launchers", "Please wait while your configuration is processed.", this.app.Windows.GetGuiObj("MainWindow"), false, "0-100", 0, "Initializing...")
        this.launcherConfigObj.LoadConfig(launcherFile)
        progress.SetRange("0-" . this.launcherConfigObj.Games.Count)
        launchersMap := Map()

        for key, config in this.launcherConfigObj.Games {
            requiredKeys := "" ; @todo Figure out how to get these
            launcherGame := EditableLauncherGame.new(this.app, key, config, requiredKeys, this.dataSource)
            launcherGame.MergeDefaults(true)
            launchersMap[key] := launcherGame
        }

        this.launchersMap := launchersMap
        progress.Finish()
    }

    VerifyRequirements() {
        if (this.app.Config.LauncherDir == "") {
            return false
        }
        
        if (this.app.Config.AssetsDir == "") {
            return false
        }

        return true
    }

    CountLaunchers() {
        return this.Launchers.Count
    }

    BuildLaunchers(updateExisting := false, owner := "MainWindow") {
        if (!this.VerifyRequirements()) {
            this.app.Notifications.Error("Required values are missing, skipping build.")
            return 0
        }

        itemCount := this.CountLaunchers()
        built := 0

        if (itemCount > 0) {
            progress := this.app.Windows.ProgressIndicator("Building Launchers", "Please wait while your launchers are built.", owner, true, "0-" . itemCount, 0, "Initializing...")
            currentItem := 1

            for key, launcherGame in this.Launchers {
                success := this.BuildLauncher(key, updateExisting, owner, progress)

                if (success) {
                    built++
                }

                currentItem++
            }

            progress.Finish()
        }
        
        this.app.Notifications.Info("Built " . built . " launchers.")
    }

    BuildLauncher(key, updateExisting := false, owner := "MainWindow", progress := "") {
        manageProgress := (progress == "")

        if (manageProgress) {
            progress := this.app.Windows.ProgressIndicator("Building Launchers", "Please wait while your launcher is built.", owner, true, "0-1", 0, "Initializing...")
        }

        if (this.Launchers.Has(key)) {
            launcherGameObj := this.Launchers[key]
            config := launcherGameObj.Config

            progress.IncrementValue(1, key . ": Discovering...")
            success := false
            exists := this.LauncherExists(key, config)

            if (updateExisting or !exists) {
                detailText := exists ? "Rebuilding launcher..." : "Building launcher..."
                progress.SetDetailText(key . ": " . detailText)

                success := this.Builder.Build(launcherGameObj)
            }

            progress.SetDetailText(key . ": Launcher built successfully.")
        }

        if (manageProgress) {
            progress.Finish()
            this.app.Notifications.Info("Built launcher: " . key . ".")
        }
        
        return success
    }

    CleanLaunchers(notify := true, owner := "MainWindow") {
        itemCount := this.CountLaunchers()
        cleaned := 0

        if (itemCount > 0) {
            progress := this.app.Windows.ProgressIndicator("Cleaning Launchers", "Please wait while your launchers are cleaned.", owner, true, "0-" . itemCount, 0, "Initializing...")
            currentItem := 1

            for key, launcherGame in this.Launchers {
                success := this.CleanLauncher(key, owner, progress)
                
                if (success) {
                    cleaned++
                }
            }
        }
        
        progress.Finish()

        if (notify) {
            this.app.Notifications.Info("Cleaned " . cleaned . " launchers.")
        }
    }

    CleanLauncher(key, owner := "MainWindow", progress := "") {
        manageProgress := (progress == "")

        if (manageProgress) {
            progress := this.app.Windows.ProgressIndicator("Cleaning Launcher", "Please wait while your launcher is cleaned.", owner, true, "0-1", 0, "Initializing...")
        }

        progress.IncrementValue(1, key . ": Cleaning launcher...")
        wasCleaned := false

        filePath := this.app.Config.AssetsDir . "\" . key . "\" . key . ".ahk"

        if (FileExist(filePath)) {
            FileDelete(filePath)
            wasCleaned := true
        }

        if (manageProgress) {
            progress.Finish()
            this.app.Notifications.Info("Cleaned launcher: " . key . ".")
        }

        return wasCleaned
    }

    GetLauncherFile(key, getAHkFile := false) {
        gameDir := getAhkFile ? this.app.Config.AssetsDir : this.app.Config.LauncherDir

        if (getAhkFile or this.app.Config.IndividualDirs) {
            gameDir .= "\" . key
        }

        ext := getAhkFile ? ".ahk" : ".exe"
        return gameDir . "\" . key . ext
    }

    LauncherExists(key, checkAHkFile := false) {
        return (FileExist(this.GetLauncherFile(key, checkAhkFile)) != "")
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

    ValidateLaunchers(launcherFileObj := "", mode := "config", owner := "MainWindow") {
        if (launcherFileObj == "") {
            launcherFileObj := this.launcherConfigObj
        }

        itemCount := launcherFileObj.Games.Count
        results := Map()

        if (itemCount > 0) {
            progress := this.app.Windows.ProgressIndicator("Validating Launchers", "Please wait while your launcher configuration is validated.", owner, true, "0-" . itemCount, 0, "Initializing...")
            currentItem := 1

            for key, config in launcherFileObj.Games {
                results[key] := this.ValidateLauncher(key, launcherFileObj, mode, owner, progress)
                currentItem++
            }

            progress.Finish()
        }

        return results
    }

    ValidateLauncher(key, launcherFileObj := "", mode := "config", owner := "MainWindow", progress := "") {
        if (launcherFileObj == "") {
            launcherFileObj := this.launcherConfigObj
        }

        manageProgress := (progress == "")

        if (manageProgress) {
            progress := this.app.Windows.ProgressIndicator("Validating Launchers", "Please wait while your launcher configuration is validated.", owner, true, "0-1", 0, "Initializing...")
        }

        result := false

        if (this.Launchers.Has(key)) {
            launcherGameObj := this.Launchers[key]

            progress.IncrementValue(1, key . ": Validating...")
            result := launcherGameObj.Validate()

            if (!result["success"]) {
                result := launcherGameObj.Edit(launcherFileObj, mode, owner)
            }

            message := result["success"] ? "Validation successful." : "Validateion failed."
            progress.SetDetailText(key . ": " . message)
        }

        if (manageProgress) {
            progress.Finish()
        }
        
        return result
    }
}
