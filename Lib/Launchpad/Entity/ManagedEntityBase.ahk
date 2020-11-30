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
    ;   is usually not recommended, as you could simply 
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

    SetDependentDefaults(config) {
        key := this.configPrefix . "ProcessId"

        if (!config.Has(key) or config[key] == "") {
            processId := ""

            if (this.ProcessType == "Exe") {
                SplitPath(this.Exe, processId)
            } else if (this.ProcessType == "Title") {
                processId := this.Key
            }

            config[key] := processId
        }
        
        key := this.configPrefix . "UsesShortcut"

        if (!config.Has(key) or config[key] == "") {
            config[key] := (this.RunType == "Shortcut")
        }

        key := this.configPrefix . "ProcessType"

        if (!config.Has(key) or config[key] == "") {
            config[key] := this.RunMethod == "RunWait" ? "" : "Exe"
        }

        return config
    }

    InitializeDefaults() {
        defaults := super.InitializeDefaults()
        defaults[this.configPrefix . "Type"] := this.defaultType
        defaults[this.configPrefix . "Class"] := this.defaultClass
        defaults[this.configPrefix . "SearchDirs"] := []
        defaults[this.configPrefix . "Exe"] := ""
        defaults[this.configPrefix . "WorkingDir"] := ""
        defaults[this.configPrefix . "RunType"] := "Command"
        defaults[this.configPrefix . "ShortcutSrc"] := ""
        defaults[this.configPrefix . "RunMethod"] := "RunWait"
        defaults[this.configPrefix . "ProcessType"] := ""
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
}
