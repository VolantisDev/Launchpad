class DetectedGame {
    key := ""
    displayName := ""
    platform := ""
    detectedKey := ""
    launcherType := ""
    gameType := ""
    installDir := ""
    launcherInstallDir := ""
    exeName := ""
    platformRef := ""
    possibleExeNames := []
    keyMap := Map()
    ; @todo Move this to properties or config or allow it to be extended
    hyphenPrefixes := ["Call of Duty", "Dragon Age"]
    ; @todo Move this to properties or config or allow it to be extended
    prioritySuffixes := ["-Win64-Shipping", "-Win32-Shipping"]
    filterExes := []

    __New(key, platform, launcherType, gameType := "Default", installDir := "", exeName := "", platformRef := "", possibleExeNames := "", displayName := "") {
        this.key := key
        this.displayName := displayName ? displayName : key
        this.platform := platform
        this.detectedKey := key
        this.launcherType := launcherType
        this.gameType := gameType
        this.installDir := installDir
        this.exeName := exeName
        this.platformRef := platformRef

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
            
        if (
            this.displayName != launcher["name"]
            || this.installDir != launcher["GameProcess"]["InstallDir"]
            || this.launcherInstallDir != launcher["LauncherProcess"]["InstallDir"]
            || this.exeName != launcher["GameProcess"]["Exe"] 
            || this.platformRef != launcher["GameProcess"]["PlatformRef"]
        ) {
            hasChanges := true
        }

        return hasChanges
    }

    UpdateLauncher(launcher) {
        modified := false

        if (this.displayName && this.key != this.displayName && launcher["name"] != this.displayName) {
            launcher["name"] := this.displayName
            modified := true
        }

        if (launcher["Platform"]["id"] != this.platform.key) {
            launcher["Platform"] := this.platform.key
            modified := true
        }

        if (this.launcherInstallDir && launcher["LauncherProcess"]["InstallDir"] != this.launcherInstallDir) {
            launcher["LauncherProcess"]["InstallDir"] := this.launcherInstallDir
        }

        if (this.installDir && launcher["GameProcess"]["InstallDir"] != this.installDir) {
            launcher["GameProcess"]["InstallDir"] := this.installDir
            modified := true
        }

        if (this.exeName && launcher["GameProcess"]["Exe"] != this.exeName) {
            launcher["GameProcess"]["Exe"] := this.exeName
            modified := true
        }

        if (modified) {
            launcher.SaveEntity(true)
        }
    }

    CreateLauncher(launcherManager) {
        config := Map(
            "Platform", this.platform.key
        )

        if (this.displayName && this.displayName != this.key) {
            config["name"] := this.displayName
        }

        if (this.launcherInstallDir) {
            config["LauncherInstallDir"] := this.launcherInstallDir
        }

        if (this.installDir) {
            config["GameInstallDir"] := this.installDir
        }

        if (this.exeName) {
            config["GameExe"] := this.exeName
        }

        if (this.platformRef) {
            config["GamePlatformRef"] := this.platformRef
        }

        entityObj := launcherManager.GetFactory().CreateEntity(this.key, config)
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
            if (RegExMatch(key, "i)(" . prefix . ") [^\-]", &match)) {
                if (match[1]) {
                    key := StrReplace(key, match[1], match[1] . " -")
                }
            }
        }

        replacements := [
            [" : ", " - "],
            [": ", " - "],
            [":", "-"],
            ["Â®", ""],
            ["â„¢", ""]
        ]

        for , vals in replacements {
            key := StrReplace(key, vals[1], vals[2])
        }

        key := RegExReplace(key, "[\\/:*?`"<>|]'")

        return key
    }

    DetectMainExe(possibleExes) {
        mainExe := ""
        containsLikelyMatch := false

        if (possibleExes.Length == 1) {
            mainExe := possibleExes[1]
        }

        nonExcludedExes := []

        if (!mainExe) {
            installDirExes := []
            priorityExes := []

            exclusions := [" Launcher", "CrashHandler"]
            
            for index, possibleExe in possibleExes {
                SplitPath(possibleExe,, &dir,, &nameNoExt)

                for exclusionIndex, pattern in exclusions {
                    if (InStr(nameNoExt, pattern)) {
                        continue 2
                    }
                }

                nonExcludedExes.Push(possibleExe)

                for suffixIndex, suffix in this.prioritySuffixes {
                    if (SubStr(nameNoExt, -StrLen(suffix)) == suffix) {
                        priorityExes.Push(possibleExe)
                    }
                }

                if (this.installDir && StrLower(dir) == StrLower(this.installDir)) {
                    installDirExes.Push(possibleExe)
                }
            }

            if (installDirExes.Length == 1) {
                mainExe := installDirExes[1]
            } else if (installDirExes.Length > 1) {
                ;containsLikelyMatch := true
                ;mainExe := installDirExes[1]
                ; TODO: Decide what to do if there is more than one exe in the main dir
            }

            if (priorityExes.Length == 1) {
                mainExe := priorityExes[1]
            } else if (priorityExes.Length > 1) {
                containsLikelyMatch := true
                mainExe := priorityExes[1]
            }
        }

        if (!mainExe && !containsLikelyMatch && nonExcludedExes.Length) {
            if (nonExcludedExes.Length == 1) {
                mainExe := nonExcludedExes[1]
            } else {
                for index, possibleExe in nonExcludedExes {
                    SplitPath(possibleExe,,,, &nameNoExt)
                    checkValues := [this.key, StrReplace(this.key, " ", "")]

                    for index, val in checkValues {
                        if (StrLower(val) == StrLower(nameNoExt)) {
                            mainExe := possibleExe
                            break 2
                        }
                    }
                }

                if (!mainExe) {
                    shortestExe := ""
                    shortestLength := ""

                    for index, possibleExe in nonExcludedExes {
                        len := StrLen(possibleExe)

                        if (shortestLength == "" || len < shortestLength) {
                            shortestExe := possibleExe
                            shortestLength := len
                        }
                    }

                    if (shortestExe) {
                        mainExe := shortestExe
                    }
                }
            }
        }

        return mainExe
    }
}