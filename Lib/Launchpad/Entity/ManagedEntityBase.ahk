class ManagedEntityBase extends EntityBase {
    defaultType := "Default"
    defaultClass := "Default"

    ; The key of the entity type to load settings and defaults from.
    EntityType {
        get => this.GetConfigValue("Type")
        set => this.SetConfigValue("Type", value)
    }

    ; The name of the AHK class that will be used to control the launcher.
    ; This is usually set by the LauncherType, but can be overridden.
    EntityClass {
        get => this.GetConfigValue("Class")
        set => this.SetConfigValue("Class", value)
    }

    InstallDir {
        get => this.GetConfigValue("InstallDir")
        set => this.SetConfigValue("InstallDir", value)
    }

    ; An array of possible parent directories where the game's launcher might exist, to be used for auto-detection.
    ; These should be as specific as possible to reduce detection time.
    SearchDirs {
        get => this.GetSearchDirs()
        set => this.SetConfigValue("SearchDirs", value)
    }

    ; This can be the full path on the system to the launcher's .exe file, or simply the name of the .exe file itself.
    ; If the .exe doesn't include the absolute path, auto-detection will be used by searching the DestinationDirs
    Exe {
        get => this.GetConfigValue("Exe")
        set => this.SetConfigValue("Exe", value)
    }

    ; How to search for the .exe if it isn't a full path already
    ; Options include:
    ; - Search (will search through each directory in SearchDirs until a match is found)
    ; - BlizzardProductDb (will search Battle.net's product.db file if it can be located for the installation directory, and the file will be found from there
    ; - Registry (will get a directory from the registry key specified by LocateRegKey and search for the file within it)
    LocateMethod {
        get => this.GetConfigValue("LocateMethod")
        set => this.SetConfigValue("LocateMethod", value)
    }

    ; If using the "Registry" method for locating the exe
    LocateRegView {
        get => this.GetConfigValue("LocateRegView")
        set => this.SetConfigValue("LocateRegView", value)
    }

    ; If using the "Registry" method for locating the exe
    LocateRegKey {
        get => this.GetConfigValue("LocateRegKey")
        set => this.SetConfigValue("LocateRegKey", value)
    }

    ; If using the "Registry" method for locating the exe
    LocateRegValue {
        get => this.GetConfigValue("LocateRegValue")
        set => this.SetConfigValue("LocateRegValue", value)
    }

    LocateRegRemovePrefix {
        get => this.GetConfigValue("LocateRegRemovePrefix")
        set => this.SetConfigValue("LocateRegRemovePrefix", value)
    }

    LocateRegRemoveSuffix {
        get => this.GetConfigValue("LocateRegRemoveSuffix")
        set => this.SetConfigValue("LocateRegRemoveSuffix", value)
    }

    ; The directory that the launcher should be run from, if set. If not set, it will be run without setting an explicit working directory, which is usually sufficient.
    WorkingDir {
        get => this.GetConfigValue("WorkingDir")
        set => this.SetConfigValue("WorkingDir", value)
    }

    ; A selection of the way that that the launcher should be launched.
    ; This is only needed for launchers that have to manage their own process.
    ; - Shortcut (Run a shortcut file)
    ; - Command (Run a command directly, the default if required)
    RunType {
        get => this.GetConfigValue("RunType")
        set => this.SetConfigValue("RunType", value)
    }

    ; Returns a value indicating whether a shortcut file will be used when starting the internally-managed game launcher
    UsesShortcut {
        get => this.GetConfigValue("UsesShortcut")
        set => this.SetConfigValue("UsesShortcut", value)
    }

    ; The shortcut file used to launch the game launcher itself. It can be one of several types of values:
    ; - The filename of an existing shortcut (.url or .lnk file, or even another .exe) that will be used to run the game.
    ; - The path of another shortcut file (.url or .lnk) on the system, which will be copied to the AssetsDir if it doesn't already exist
    ; - The path of an .exe file on the system to which a shortcut will be created in AssetsDir if it doesn't already exist. Using this option
    ;   is usually not necessary, since you can run the .exe directly instead.
    ;
    ; This is typically only needed if the "Shortcut" LauncherRunType is selected.
    ShortcutSrc {
        get => this.GetConfigValue("ShortcutSrc")
        set => this.SetConfigValue("ShortcutSrc", value)
    }

    ; Which method to use to run the RunCmd
    ; - RunWait (the default, uses RunWait to both run a process and wait until it completes in one step. This is most efficient if it works.)
    ; - Run (Uses Run, then watches for the game window and waits until the window opens (if needed) and then closes)
    ; - Scheduled (Creates an immediate scheduled task that runs the game, then waits until the window opens (if needed) and then closes)
    RunMethod {
        get => this.GetConfigValue("RunMethod")
        set => this.SetConfigValue("RunMethod", value)
    }

    ReplaceProcess {
        get => this.GetConfigValue("ReplaceProcess")
        set => this.SetConfigValue("ReplaceProcess", value)
    }

    ; Which method to use to wait for the game to close if the GameRunType requires it. This is not needed if the GameRunType is RunWait.
    ; - "Exe" (Waits for the game's .exe process to start if it hasn't already, and then waits for it to stop again. This is the default if the game type is not RunWait)
    ; - "Title" (Waits for the game's window title to open if it isn't already, and then waits for it to close again)
    ; - "Class" (Wait's for the game's window class to open if it isn't already, and then waits for it to close again)
    ProcessType {
        get => this.GetConfigValue("ProcessType")
        set => this.SetConfigValue("ProcessType", value)
    }

    ; This value's type is dependent on the GameProcessType above. It can often be detected from other values, and is not needed if the GameRunType is RunWait.
    ; - Exe - This value will default to the GameExe unless overridden
    ; - Title - This value will default to the game's Key unless overridden
    ; - Class - This value should be set to the game's window class
    ProcessId {
        get => this.GetConfigValue("ProcessId")
        set => this.SetConfigValue("ProcessId", value)
    }

    ; The number of seconds to wait before giving up when waiting for a process
    ProcessTimeout {
        get => this.GetConfigValue("ProcessTimeout")
        set => this.SetConfigValue("ProcessTimeout", value)
    }

    ; The command that will be used to run the game's launcher, typically only used if LauncherRunType is "cmd"
    RunCmd {
        get => this.GetConfigValue("RunCmd")
        set => this.SetConfigValue("RunCmd", value)
    }

    InitializeRequiredConfigKeys(requiredConfigKeys := "") {
        super.InitializeRequiredConfigKeys(requiredConfigKeys)
        this.AddRequiredConfigKeys([this.configPrefix . "Type", this.configPrefix . "Class"])
    }

    GetSearchDirs() {
        dirs := this.GetConfigValue("SearchDirs")

        if (dirs != "" and Type(dirs) == "String") {
            dirs := [dirs]
        }

        return dirs
    }

    GetDataSourceItemKey() {
        return this.EntityType
    }

    SetDependentValues(config) {
        processTypeKey := this.configPrefix . "ProcessType"

        if (!config.Has(processTypeKey) or config[processTypeKey] == "") {
            config[processTypeKey] := this.RunMethod == "RunWait" ? "" : "Exe"
        }

        key := this.configPrefix . "ProcessId"

        if (!config.Has(key) or config[key] == "") {
            processId := ""

            if (config[processTypeKey] == "Exe") {
                SplitPath(this.Exe, processId)
            } else if (config[processTypeKey] == "Title") {
                processId := this.Key
            }

            config[key] := processId
        }

        ; @ Run Type
        runTypeKey := this.configPrefix . "RunType"
        shortcutSrcKey := this.configPrefix . "ShortcutSrc"
        runCmdKey := this.configPrefix . "RunCmd"
        hasShortcutSrc := (config.Has(shortcutSrcKey) and config[shortcutSrcKey] != "")
        hasRunCmd := (config.Has(runCmdKey) and config[runCmdKey] != "")
        usesShortcutKey := this.configPrefix . "UsesShortcut"

        if (config.Has(usesShortcutKey) and config[usesShortcutKey]) {
            config[runTypeKey] := "Shortcut"
        } else if (config.Has(usesShortcutKey) and !config[usesShortcutKey] and config[runTypeKey] == "Shortcut") {
            config[runTypeKey] := "Command"
        } else if (config.Has(runTypeKey)) {
            if (config[runTypeKey] == "Shortcut" and !hasShortcutSrc and hasRunCmd) {
                config[runTypeKey] := "Command"
            } else if (config[runTypeKey] == "Command" and !hasRunCmd and hasShortcutSrc ) {
                config[runTypeKey] := "Shortcut"
            }
        }

        if (!config.Has(usesShortcutKey) or config[usesShortcutKey] == "") {
            config[usesShortcutKey] := (this.RunType == "Shortcut")
        }

        return config
    }

    InitializeDefaults() {
        defaults := super.InitializeDefaults()
        defaults[this.configPrefix . "Type"] := this.defaultType
        defaults[this.configPrefix . "Class"] := this.defaultClass
        defaults[this.configPrefix . "SearchDirs"] := [A_ProgramFiles]
        defaults[this.configPrefix . "Exe"] := ""
        defaults[this.configPrefix . "LocateMethod"] := "SearchDirs"
        defaults[this.configPrefix . "LocateRegView"] := 64
        defaults[this.configPrefix . "LocateRegKey"] := ""
        defaults[this.configPrefix . "LocateRegValue"] := ""
        defaults[this.configPrefix . "LocateRegRemovePrefix"] := ""
        defaults[this.configPrefix . "LocateRegRemoveSuffix"] := ""
        defaults[this.configPrefix . "BlizzardProductKey"] := "bna"
        defaults[this.configPrefix . "WorkingDir"] := ""
        defaults[this.configPrefix . "RunType"] := "Command"
        defaults[this.configPrefix . "ReplaceProcess"] := false
        defaults[this.configPrefix . "ShortcutSrc"] := ""
        defaults[this.configPrefix . "RunMethod"] := "RunWait"
        defaults[this.configPrefix . "ProcessType"] := "Exe"
        defaults[this.configPrefix . "ProcessId"] := ""
        defaults[this.configPrefix . "ProcessTimeout"] := 30
        defaults[this.configPrefix . "RunCmd"] := ""
        return defaults
    }

    Validate() {
        validateResult := super.Validate()

        if (((this.UsesShortcut and this.RunCmd == "") and this.ShortcutSrc == "") and !this.ShortcutFileExists()) {
            validateResult["success"] := false
            validateResult["invalidFields"].push("ShortcutSrc")
        }

        if (this.ShortcutSrc == "" and this.RunCmd == "") {
            validateResult["success"] := false
            validateResult["invalidFields"].push("RunCmd")
        }

        ; @todo more launcher type validation
        ; @ todo more game type validation

        return validateResult
    }

    ShortcutFileExists() {
        shortcutSrc := this.ShortcutSrc != "" ? this.ShortcutSrc : this.GetAssetPath(this.Key . ".lnk")

        exists := FileExist(shortcutSrc)

        if (!exists) {
            shortcutSrc := this.GetAssetPath(this.Key . ".url")
            exists := FileExist(shortcutSrc)
        }

        return exists
    }

    LocateInstallDir() {
        installDir := ""

        ; @todo Figure out more sources for determining the install dir

        if (this.LocateMethod == "BlizzardProductDb") {
            blizzardDir := this.GetBlizzardProductDir()

            if (blizzardDir != "") {
                installDir := blizzardDir
            }
        }

        return installDir
    }

    LocateExe() {
        return this.LocateFile(this.Exe)
    }

    LocateFile(filePattern) {
        filePath := ""

        if (filePattern != "") {
            SplitPath(filePattern,,,,, fileDrive)
            
            if (fileDrive != "") {
                filePath := filePattern
            } else {
                searchDirs := []

                if (this.InstallDir != "") {
                    searchDirs.Push(this.InstallDir)
                } else if (this.LocateMethod == "SearchDirs") {
                    if (Type(this.SearchDirs) == "Array" and this.SearchDirs.Length > 0) {
                        searchDirs := this.SearchDirs
                    }
                } else if (this.LocateMethod == "Registry") {
                    regKey := this.LocateRegKey

                    if (regKey != "") {
                        SetRegView(this.LocateRegView)
                        regDir := RegRead(this.LocateRegKey, this.LocateRegValue)
                        SetRegView("Default")

                        if (regDir != "") {
                            if (this.LocateRegRemovePrefix) {
                                regDir := StrReplace(regDir, this.LocateRegRemovePrefix) ; @todo only remove if it's at the beginning of the string
                            }

                            if (this.LocateRegRemoveSuffix) {
                                regDir := StrReplace(regDir, this.LocateRegRemoveSuffix) ; @todo only remove if it's at the end of the string
                            }
                            
                            searchDirs.Push(regDir)
                        }
                    }
                } else if (this.LocateMethod == "BlizzardProductDb") {
                    blizzardDir := this.GetBlizzardProductDir()

                    if (blizzardDir != "") {
                        searchDirs.Push(blizzardDir)
                    }
                }

                filePath := this.LocateFileInSearchDirs(filePattern, searchDirs)
            }
        }

        return filePath
    }

    LocateFileInSearchDirs(filePattern, searchDirs := "") {
        path := ""

        if (searchDirs == "") {
            searchDirs := this.SearchDirs
        }

        if (!Type(searchDirs) == "Array") {
            searchDirs := [searchDirs]
        }

        for index, searchDir in searchDirs {
            Loop Files, searchDir . "\" . filePattern, "R" {
                path := A_LoopFileFullPath
                break
            }

            if (path != "") {
                break
            }
        }

        return path
    }

    GetBlizzardProductKey() {
        return "bna" ; Default to the Battle.net client itself
    }

    GetBlizzardProductDir() {
        path := ""
        compiledFile := A_AppDataCommon . "\Battle.net\Agent\product.db"
        gameId := this.GetBlizzardProductKey

        if (gameId != "" and FileExist(compiledFile)) {
            protoFile := A_ScriptDir . "\Resources\Dependencies\BlizzardProductDb.proto"
            dbMap := Protobuf.FromFile(compiledFile, "Database", protoFile)
            
            if (Type(dbMap) == "Map" and dbMap.Has("productInstall")) {
                productInstalls := (Type(dbMap.Has("productInstall")) != "Array") ? dbMap["productInstall"] : Array(dbMap["productInstall"])

                for index, productData in productInstalls {
                    if (productData.Has("productCode") and productData["productCode"] == gameId) {
                        path := (productData.Has("settings") and productData["settings"].Has("installPath")) ? productData["settings"]["installPath"] : ""
                        break
                    }
                }
            }
        }

        return path
    }
}
