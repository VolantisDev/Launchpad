class DetectedGame {
    key := ""
    displayName := ""
    platform := ""
    detectedKey := ""
    launcherType := ""
    gameType := ""
    installDir := ""
    exeName := ""
    launcherSpecificId := ""
    possibleExeNames := []
    keyMap := Map()
    hyphenPrefixes := ["Call of Duty", "Dragon Age"]
    prioritySuffixes := ["-Win64-Shipping", "-Win32-Shipping"]
    filterExes := []

    __New(key, platform, launcherType, gameType := "Default", installDir := "", exeName := "", launcherSpecificId := "", possibleExeNames := "") {
        this.key := key
        this.displayName := key
        this.platform := platform
        this.detectedKey := key
        this.launcherType := launcherType
        this.gameType := gameType
        this.installDir := installDir
        this.exeName := exeName
        this.launcherSpecificId := launcherSpecificId

        if (possibleExeNames) {
            if (Type(possibleExeNames) == "String") {
                possibleExeNames := [possibleExeNames]
            }

            this.possibleExeNames := possibleExeNames
        }

        this.AutoDetectValues()
    }

    HasChanges(launcher) {
        hasChanges := false
            
        if (this.launcherType != launcher.ManagedLauncher.EntityType || this.gameType != launcher.ManagedLauncher.ManagedGame.EntityType || this.installDir != launcher.ManagedLauncher.ManagedGame.InstallDir || this.exeName != launcher.ManagedLauncher.ManagedGame.Exe || this.launcherSpecificId != launcher.ManagedLauncher.ManagedGame.LauncherSpecificId) {
            hasChanges := true
        }

        return hasChanges
    }

    UpdateLauncher(launcher) {
        modified := false

        if (this.displayName) {
            launcher.DisplayName := this.displayName
            modified := true
        }
                
        if (this.launcherType) {
            launcher.LauncherType := this.launcherType
            modified := true
        }

        if (this.gameType) {
            launcher.GameType := this.gameType
            modified := true
        }

        if (this.installDir) {
            launcher.ManagedLauncher.ManagedGame.InstallDir := this.installDir
            modified := true
        }

        if (this.exeName) {
            launcher.ManagedLauncher.ManagedGame.Exe := this.exeName
            modified := true
        }

        if (modified) {
            launcher.SaveModifiedData()
        }
    }

    CreateLauncher(launcherManager) {
        config := Map("LauncherType", this.launcherType, "GameType", this.gameType)

        if (this.displayName) {
            config["DisplayName"] := this.displayName
        }

        if (this.installDir) {
            config["GameInstallDir"] := this.installDir
        }

        if (this.exeName) {
            config["GameExe"] := this.exeName
        }

        if (this.launcherSpecificId) {
            config["GameLauncherSpecificId"] := this.launcherSpecificId
        }

        entity := LauncherEntity.new(launcherManager.app, this.key, config)
        launcherManager.AddLauncher(this.key, entity)
    }

    AutoDetectValues() {
        this.key := this.FilterKey(this.key)

        if (!this.exeName && this.possibleExeNames.Length) {
            this.exeName := this.DetectMainExe(this.possibleExeNames)
        }
    }

    FilterKey(key) {
        for old, new in this.keyMap {
            if (key == old) {
                key := new
                break
            }
        }

        for index, prefix in this.hyphenPrefixes {
            if (RegExMatch(key, "i)(" . prefix . ") [^\-]", match)) {
                if (match[1]) {
                    key := StrReplace(key, match[1], match[1] . " -")
                }
            }
        }

        key := StrReplace(key, ": ", " - ")
        key := StrReplace(key, ":", "")
        key := StrReplace(key, "\", "")
        key := StrReplace(key, "/", "")
        key := StrReplace(key, "*", "")
        key := StrReplace(key, "?", "")
        key := StrReplace(key, "`"", "")
        key := StrReplace(key, "Â®", "")
        key := StrReplace(key, "â„¢", "")

        return key
    }

    DetectMainExe(possibleExes) {
        mainExe := ""
        containsLikelyMatch := false

        if (possibleExes.Length == 1) {
            mainExe := possibleExes[1]
        }

        if (!mainExe) {
            installDirExes := []
            priorityExes := []
            
            for index, possibleExe in possibleExes {
                SplitPath(possibleExe,, dir,, nameNoExt)

                for suffixIndex, suffix in this.prioritySuffixes {
                    if (SubStr(nameNoExt, -StrLen(suffix)) == suffix) {
                        priorityExes.Push(possibleExe)
                    }
                }

                if (this.installDir && StrLower(dir) == StrLower(this.installDir)) {
                    installDirExes.Push(possibleExe)
                }
            }

            if (priorityExes.Length == 1) {
                mainExe := priorityExes[1]
            } else if (priorityExes.Length > 1) {
                containsLikelyMatch := true
                ; @todo determine what to do if there is more than one priority exe file
            }

            if (installDirExes.Length == 1) {
                mainExe := installDirExes[1]
            } else if (installDirExes.Length > 1) {
                containsLikelyMatch := true
                ; @todo Decide what to do if there is more than one exe in the main dir
            }
        }

        if (!mainExe && !containsLikelyMatch && possibleExes.Length) {
            for index, possibleExe in possibleExes {
                SplitPath(possibleExe,,,, nameNoExt)
                checkValues := [this.key, StrReplace(this.key, " ", "")]

                for index, val in checkValues {
                    if (val == nameNoExt) {
                        mainExe := possibleExe
                        break 2
                    }
                }
            }
        }

        return mainExe
    }
}
