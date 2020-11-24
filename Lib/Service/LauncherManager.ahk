class LauncherManager extends ServiceBase {
    launchersObj := ""
    builderObj := ""

    Launchers[] {
        get => this.launchersObj
        set => this.launchersObj := value
    }

    Builder[] {
        get {
            return this.builderObj
        }
        set {
            return this.builderObj := value
        }
    }

    __New(app, builderObj, launcherFile := "", autoLoad := false) {
        this.launchersObj := LauncherConfig.new(app, launcherFile, autoLoad)
        this.builderObj := builderObj
        super.__New(app)
    }

    VerifyRequirements() {
        if (this.app.AppConfig.LauncherDir == "") {
            return false
        }
        
        if (this.app.AppConfig.AssetsDir == "") {
            return false
        }

        return true
    }

    CountLaunchers() {
        return this.Launchers.Games.Count
    }

    BuildLaunchers(updateExisting := false, owner := "MainWindow") {
        if (!this.VerifyRequirements()) {
            this.app.Notifications.Error("Required values are missing, skipping build.")
            return 0
        }

        itemCount := this.CountLaunchers()
        built := 0

        if (itemCount > 0) {
            progress := this.app.GuiManager.ProgressIndicator("Building Launchers", "Please wait while your launchers are built.", owner, true, "0-" . itemCount, 0, "Initializing...")
            currentItem := 1

            for key, config in this.Launchers.Games {
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
            progress := this.app.GuiManager.ProgressIndicator("Building Launchers", "Please wait while your launcher is built.", owner, true, "0-1", 0, "Initializing...")
        }

        launcherGameObj := this.GetLauncherGame(key)
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
            progress := this.app.GuiManager.ProgressIndicator("Cleaning Launchers", "Please wait while your launchers are cleaned.", owner, true, "0-" . itemCount, 0, "Initializing...")
            currentItem := 1

            for key, config in this.Launchers.Games {
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
            progress := this.app.GuiManager.ProgressIndicator("Cleaning Launcher", "Please wait while your launcher is cleaned.", owner, true, "0-1", 0, "Initializing...")
        }

        progress.IncrementValue(1, key . ": Cleaning launcher...")
        wasCleaned := false

        filePath := this.AppConfig.AssetsDir . "\" . key . "\" . key . ".ahk"

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
        gameDir := getAhkFile ? this.app.AppConfig.AssetsDir : this.app.AppConfig.LauncherDir

        if (getAhkFile or this.AppConfig.IndividualDirs) {
            gameDir .= "\" . key
        }

        ext := getAhkFile ? ".ahk" : ".exe"
        return gameDir . "\" . key . ext
    }

    LauncherExists(key, checkAHkFile := false) {
        return (FileExist(this.GetLauncherFile(key, checkAhkFile)) != "")
    }

    LoadLauncherFile(launcherFile := "") {
        this.Launchers.LoadConfig(launcherFile)
    }

    DetectLauncherFile(launcherFile := "") {
        if (launcherFile == "") {
            launcherFile := this.app.AppConfig.GetRawValue("LauncherFile")
        }
        
        if (!launcherFile) {
            launcherFile := this.ChangeLauncherFile()
        }

        return launcherFile
    }

    ChangeLauncherFile(launcherFile := "") {
        if (launcherFile == "") {
            launcherFile := this.app.AppConfig.GetRawValue("LauncherFile")
        }

        launcherFile := this.SelectLauncherFile(launcherFile)

        if (launcherFile != "") {
            this.app.AppConfig.LauncherFile := launcherFile
        }

        return launcherFile
    }

    SelectLauncherFile(existingFile := "") {
        return FileSelect(3, existingFile, "Select the Launchers file to use", "JSON Documents (*.json)")
    }

    OpenLauncherFile() {
        Run(this.app.AppConfig.LauncherFile)
    }

    DetectLauncherDir(launcherDir := "") {
        if (launcherDir == "") {
            launcherDir := this.app.AppConfig.GetRawValue("LauncherDir")
        }

        if (!launcherDir) {
            launcherDir := this.ChangeLauncherDir()
        }

        return launcherDir
    }

    ChangeLauncherDir(launcherDir := "") {
        if (launcherDir == "") {
            launcherDir := this.app.AppConfig.GetRawValue("LauncherDir")
        }

        launcherDir := this.SelectLauncherDir(launcherDir)

        if (launcherDir != "") {
            this.app.AppConfig.LauncherDir := launcherDir
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
        Run(this.app.AppConfig.LauncherDir)
    }

    DetectAssetsDir(assetsDir := "") {
        if (assetsDir == "") {
            assetsDir := this.app.AppConfig.GetRawValue("AssetsDir")
        }

        if (!assetsDir) {
            assetsDir := this.ChangeAssetsDir(assetsDir)
        }

        return assetsDir
    }

    ChangeAssetsDir(assetsDir := "") {
        if (assetsDir == "") {
            assetsDir := this.app.AppConfig.GetRawValue("AssetsDir")
        }

        assetsDir := this.SelectAssetsDir(assetsDir)

        if (assetsDir != "") {
            this.app.AppConfig.AssetsDir := assetsDir
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
        Run(this.app.AppConfig.AssetsDir)
    }
    
    GetLauncherGame(key, launcherFileObj := "") {
        if (launcherFileObj == "") {
            launcherFileObj := this.launchersObj
        }

        return launcherFileObj.Games.Has(key) ? LauncherGame.new(this.app, key, launcherFileObj.Games[key]) : ""
    }

    ValidateLaunchers(launcherFileObj := "", mode := "config", owner := "MainWindow") {
        if (launcherFileObj == "") {
            launcherFileObj := this.launchersObj
        }

        itemCount := launcherFileObj.Games.Count
        results := Map()

        if (itemCount > 0) {
            progress := this.app.GuiManager.ProgressIndicator("Validating Launchers", "Please wait while your launcher configuration is validated.", owner, true, "0-" . itemCount, 0, "Initializing...")
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
            launcherFileObj := this.launchersObj
        }

        manageProgress := (progress == "")

        if (manageProgress) {
            progress := this.app.GuiManager.ProgressIndicator("Validating Launchers", "Please wait while your launcher configuration is validated.", owner, true, "0-1", 0, "Initializing...")
        }

        launcherGameObj := this.GetLauncherGame(key, launcherFileObj)

        progress.IncrementValue(1, key . ": Validating...")
        result := launcherGameObj.Validate()

        if (!result["success"]) {
            result := launcherGameObj.Edit(launcherFileObj, mode, owner)
        }

        message := result["success"] ? "Validation successful." : "Validateion failed."
        progress.SetDetailText(key . ": " . message)

        if (manageProgress) {
            progress.Finish()
        }
        
        return result
    }
}
