class GamePlatformBase {
    app := ""
    installDir := ""
    exePath := ""
    uninstallCmd := ""
    installedVersion := ""
    latestVersion := ""
    libraryDirs := []
    launcherType := "Default"
    gameType := "Default"
    displayName := ""

    __New(app, installDir := "", exePath := "", installedVersion := "", uninstallCmd := "", libraryDirs := "") {
        this.app := app
        this.installDir := installDir
        this.exePath := exePath
        this.installedVersion := installedVersion
        this.uninstallCmd := ""

        if (libraryDirs != "") {
            if (Type(libraryDirs) == "String") {
                libraryDirs := [libraryDirs]
            }

            this.libraryDirs := libraryDirs
        }
    }

    LibraryDirExists(dir) {
        exists := false

        if (this.libraryDirs) {
            for index, key in this.libraryDirs {
                if (key == dir) {
                    exists := true
                    break
                }
            }
        }
        
        return exists
    }

    GetLibraryDirs() {
        return this.libraryDirs
    }

    GetInstallDir() {
        return this.installDir
    }

    GetExePath() {
        return this.exePath
    }

    GetUninstallCmd() {
        return this.uninstallCmd
    }

    OpenDir() {
        installDir := this.GetInstallDir()

        if (installDir) {
            Run(installDir)
        }
    }

    Run() {
        exePath := this.GetExePath()

        if (exePath) {
            Run(exePath)
        }
    }

    IsInstalled() {
        exePath := this.GetExePath()
        return (exePath && FileExist(exePath))
    }

    NeedsUpdate() {
        return this.VersionIsOutdated(this.GetLatestVersion(), this.GetInstalledVersion())
    }

    VersionIsOutdated(latestVersion, installedVersion) {
        splitLatestVersion := StrSplit(latestVersion, ".")
        splitInstalledVersion := StrSplit(installedVersion, ".")

        for (index, numPart in splitInstalledVersion) {
            latestVersionPart := splitLatestVersion.Has(index) ? splitLatestVersion[index] : 0

            if ((latestVersionPart + 0) > (numPart + 0)) {
                return true
            } else if ((latestVersionPart + 0) < (numPart + 0)) {
                return false
            } 
        }

        return false
    }

    GetInstalledVersion() {
        if (!this.installedVersion) {
            this.installedVersion := this.LookupInstalledVersion()
        }

        return this.installedVersion
    }

    GetLatestVersion() {
        if (!this.latestVersion) {
            this.latestVerison := this.LookupLatestVersion()
        }

        return this.latestVersion
    }

    LookupInstalledVersion() {
        return ""
    }

    LookupLatestVersion() {
        return ""
    }

    Update() {  
        if (this.NeedsUpdate()) {
            this.Install()
        }
    }

    Install() {

    }

    Uninstall() {
        if (this.uninstallCmd) {
            result := MsgBox("Are you sure you want to uninstall " . this.displayName . "?", "Uninstall " . this.displayName, "YesNo")
        
            if (result == "Yes") {
                RunWait(this.uninstallCmd)
            }
        }
    }

    ExeIsValid(exeName, fullPath) {
        filterExes := []
        filterExes.Push("UnityCrashHandler64.exe")
        filterExes.Push("UnityCrashHandler32.exe")
        filterExes.Push("UnityCrashHandler.exe")
        filterExes.Push("OriginThinSetup.exe")
        filterExes.Push("vc_redist.x64.exe")
        filterExes.Push("vc_redist.x86.exe")
        filterExes.Push("vcredist_x86.exe")
        filterExes.Push("vcredist_x64.exe")
        filterExes.Push("vc_redist_2015_x64.exe")
        filterExes.Push("overlayinjector.exe")
        filterExes.Push("Cleanup.exe")
        filterExes.Push("Touchup.exe")
        filterExes.Push("ActivationUI.exe")
        filterExes.Push("DXSETUP.exe")
        filterExes.Push("BlizzardBrowser.exe")
        filterExes.Push("UnSetupNativeWrapper.exe")
        filterExes.Push("UnrealLightmass.exe")
        filterExes.Push("UE3ShaderCompileWorker.exe")
        filterExes.Push("QuickTimeUpdateHelper.exe")
        filterExes.Push("QTPluginInstaller.exe")
        filterExes.Push("CrashReporter.exe")
        filterExes.Push("CrashReportClient.exe")
        filterExes.Push("CefSharp.BrowserSubprocess.exe")
        filterExes.Push("ReportCodBug.exe")
        filterExes.Push("dxwebsetup.exe")
        filterExes.Push("EasyAntiCheat_Setup.exe")
        filterExes.Push("UnrealCEFSubProcess.exe")
        filterExes.Push("setup_redlauncher.exe") ; Added for CP2077
        filterExes.Push("REDEngineErrorReporter.exe") ; Added for CP2077
        filterExes.Push("REDprelauncher.exe") ; Added for CP2077
        filterExes.Push("7za.exe")
        filterExes.Push("breakpad_server.exe") ; Added for Detroit: Become Human
        filterExes.Push("vconsole2.exe") ; Added for Half-Life: Alyx
        filterExes.Push("bspzip.exe")
        filterExes.Push("captioncompiler.exe")
        filterExes.Push("demoinfo.exe")
        filterExes.Push("UNSTALL.EXE")
        filterExes.Push("SETSOUND.EXE")
        filterExes.Push("dosbox.exe")
        filterExes.Push("QtWebEngineProcess.exe")
        filterExes.Push("Benchmark.exe")
        filterExes.Push("CrashUploader.Publish.exe")
        filterExes.Push("ipy64.exe")
        filterExes.Push("ipy.exe")
        filterExes.Push("sysinfo.exe")
        filterExes.Push("register.exe")
        filterExes.Push("LuaCompiler.exe")
        filterExes.Push("sandboxpython.exe")

        valid := !InStr(fullPath, "\__Installer\")

        if (valid) {
            valid := !InStr(fullPath, "\DotNetCore\")
        }

        if (valid) {
            valid := !InStr(fullPath, "\Redist\")
        }

        if (valid) {
            valid := !InStr(fullPath, "\Redistributables\")
        }

        if (valid) {
            valid := !InStr(fullPath, "\ModTools\")
        }

        if (valid) {
            valid := !InStr(fullPath, "\mono\")
        }

        if (valid) {
            valid := !InStr(fullPath, "\test\")
        }

        if (valid) {
            for index, exe in filterExes {
                if StrLower(A_LoopFileName) == StrLower(exe) {
                    valid := false
                    break
                }
            }
        }

        return valid
    }

    DetectInstalledGames() {
        games := []

        for index, dir in this.GetLibraryDirs() {
            Loop Files dir . "\*", "D" {
                key := A_LoopFileName
                installDir := A_LoopFileFullPath
                possibleExes := []
                exeName := ""

                Loop Files installDir . "\*.exe", "R" {
                    if (this.ExeIsValid(A_LoopFileName, A_LoopFileFullPath)) {
                        possibleExes.Push(A_LoopFileFullPath)
                    }
                }

                exeName := this.DetermineMainExe(key, possibleExes)
                launcherSpecificId := key
                games.Push(DetectedGame.new(key, this, this.launcherType, this.gameType, installDir, exeName, launcherSpecificId, possibleExes))
            }
        }

        return games
    }

    DetermineMainExe(key, possibleExes) {
        dataSource := this.app.DataSources.GetItem()
        dsData := this.GetDataSourceDefaults(dataSource, key)

        mainExe := ""

        if (possibleExes.Length == 1) {
            mainExe := possibleExes[1]
        } else if (possibleExes.Length > 1 && dsData.Has("GameExe")) {
            for index, possibleExe in possibleExes {
                SplitPath(possibleExe, fileName)

                if (dsData["GameExe"] == fileName) {
                    mainExe := possibleExe
                    break
                }
            }
        }

        return mainExe
    }

    GetDataSourceDefaults(dataSource, key) {
        defaults := Map()
        dsData := dataSource.ReadJson(key, "Games")

        if (dsData != "" && dsData.Has("Defaults")) {
            defaults := this.MergeFromObject(defaults, dsData["Defaults"], false)
        }

        return defaults
    }

    MergeFromObject(mainObject, defaults, overwriteKeys := false) {
        for key, value in defaults {
            if (overwriteKeys or !mainObject.Has(key)) {
                if (value == "true" or value == "false") {
                    mainObject[key] := (value == "true")
                } else {
                    mainObject[key] := value
                }
            }
        }

        return mainObject
    }
}
