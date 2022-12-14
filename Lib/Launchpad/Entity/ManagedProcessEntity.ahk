class ManagedProcessEntity extends FieldableEntity {
    defaultType := "Default"
    defaultClass := "Default"

    DiscoverParentEntity(container, eventMgr, id, storageObj, idSanitizer) {
        return container.Get("entity_manager.launcher")[id]
    }

    GetDefaultFieldGroups() {
        groups := super.GetDefaultFieldGroups()

        groups["locations"] := Map(
            "name", "Locations",
            "weight", 100
        )

        groups["registry"] := Map(
            "name", "Registry",
            "weight", 125
        )

        groups["process"] := Map(
            "name", "Process",
            "weight", 150
        )

        return groups
    }

    BaseFieldDefinitions() {
        definitions := super.BaseFieldDefinitions()

        definitions["name"]["formField"] := false

        definitions["Launcher"] := Map(
            "storageKey", "",
            "type", "entity_reference",
            "entityType", "launcher",
            "required", true,
            "formField", false,
            "callbacks", Map(
                "GetValue", ObjBindMethod(this, "GetId"),
                "SetValue", ObjBindMethod(this, "SetId"),
                "HasValue", ObjBindMethod(this, "HasId"),
                "HasOverride", ObjBindMethod(this, "HasId"),
                "IsEmpty", ObjBindMethod(this, "HasId", true),
                "DeleteValue", ""
            )
        )

        definitions["EntityType"] := Map(
            "default", this.defaultType,
            "description", "The key of the managed type to load settings and defaults from.",
            "required", true,
            "storageKey", this.configPrefix . "Type",
            "widget", "select",
            "selectOptionsCallback", ObjBindMethod(this, "ListEntities", false, true),
            "group", "general"
        )

        definitions["EntityClass"] := Map(
            "default", this.defaultClass,
            "description", "The name of the AHK class that will be used to control the managed entity.",
            "formField", false,
            "storageKey", this.configPrefix . "Class",
            "required", true,
            "group", "advanced",
            "modes", Map(
                "simple", Map("formField", false)
            ),
        )

        definitions["SearchDirs"] := Map(
            "type", "directory",
            "mustExist", false,
            "storageKey", this.configPrefix . "SearchDirs",
            "default", [A_ProgramFiles],
            "description", "Possible parent directories where the game's launcher might exist, to be used for auto-detection.",
            "help", "These should be as specific as possible to reduce detection time.",
            "multiple", true,
            "group", "locations",
            "modes", Map(
                "simple", Map("formField", false)
            )
        )

        definitions["InstallDir"] := Map(
            "type", "directory",
            "mustExist", false,
            "storageKey", this.configPrefix . "InstallDir",
            "group", "locations",
            "modes", Map(
                "simple", Map("group", "general")
            ),
            "description", "Select the installation folder, or use default for auto-detection."
        )

        definitions["Exe"] := Map(
            "type", "file",
            "fileMask", "*.exe",
            "mustExist", false,
            "storageKey", this.configPrefix . "Exe",
            "description", "This can be the full path on the system to the launcher's .exe file, or simply the name of the .exe file itself.",
            "help", "If the .exe doesn't include the absolute path, auto-detection will be used by searching the DestinationDirs.",
            "group", "locations",
            "modes", Map(
                "simple", Map("group", "general")
            )
        )

        ; Options include:
        ; - Search (will search through each directory in SearchDirs until a match is found)
        ; - BlizzardProductDb (will search Battle.net's product.db file if it can be located for the installation directory, and the file will be found from there
        ; - Registry (will get a directory from the registry key specified by LocateRegKey and search for the file within it)
        definitions["LocateMethod"] := Map(
            "storageKey", this.configPrefix . "LocateMethod",
            "default", "SearchDirs",
            "description", "How to search for the .exe if it isn't a full path already",
            "group", "general",
            "modes", Map(
                "simple", Map("formField", false)
            ),
            "widget", "select",
            "selectOptionsCallback", ObjBindMethod(this, "ListLocateMethods"),
            "help", "Search: Searches a list of possible directories (Defaulting to some common possibilities) for the .exe file and uses that directory`nRegistry: Looks for the provided registry key and uses its value as the install path if present`nBlizzardProductDb: Searches for PlatformRef within the Blizzard product.db file if present"
        )

        definitions["WindowTitle"] := Map(
            "storageKey", this.configPrefix . "WindowTitle",
            "group", "process"
        )

        definitions["LocateRegView"] := Map(
            "storageKey", this.configPrefix . "LocateRegView",
            "default", 64,
            "group", "registry",
            "widget", "select",
            "selectOptionsCallback", ObjBindMethod(this, "ListRegViews"),
            "description", "The registry view to use when locating the install dir.",
            "modes", Map(
                "simple", Map("formField", false)
            )
        )

        definitions["LocateRegKey"] := Map(
            "storageKey", this.configPrefix . "LocateRegKey",
            "group", "registry",
            "description", "The registry key to look up the install dir within.",
            "help", "Path parts should be separated with backslashes and must start with one of: HKEY_LOCAL_MACHINE, HKEY_USERS, HKEY_CURRENT_USER, HKEY_CLASSES_ROOT, HKEY_CURRENT_CONFIG, or the abbreviation of one of those. To read from a remote registry, prefix the root path with two backslashes and the computer name.`n`nSimple example: HKLM\Path\To\Key`nRemote example: \\OTHERPC\HKLM\Path\To\Key",
            "modes", Map(
                "simple", Map("formField", false)
            )
        )

        definitions["LocateRegValue"] := Map(
            "storageKey", this.configPrefix . "LocateRegValue",
            "group", "registry",
            "description", "The name of the registry value to look up within the specified key.",
            "help", "Example: InstallPath",
            "modes", Map(
                "simple", Map("formField", false)
            )
        )

        definitions["LocateRegRemovePrefix"] := Map(
            "storageKey", this.configPrefix . "LocateRegRemovePrefix",
            "group", "registry",
            "modes", Map(
                "simple", Map("formField", false)
            )
        )

        definitions["LocateRegRemoveSuffix"] := Map(
            "storageKey", this.configPrefix . "LocateRegRemoveSuffix",
            "group", "registry",
            "modes", Map(
                "simple", Map("formField", false)
            )
        )

        definitions["LocateRegStripQuotes"] := Map(
            "storageKey", this.configPrefix . "LocateRegStripQuotes",
            "default", false,
            "group", "registry",
            "description", "Strip quotes from registry value",
            "modes", Map(
                "simple", Map("formField", false)
            )
        )

        definitions["PlatformRef"] := Map(
            "storageKey", this.configPrefix . "PlatformRef",
            "description", "If the item is known to the launcher by a specific ID, it should be stored here.",
            "group", "general"
        )

        definitions["WorkingDir"] := Map(
            "type", "directory",
            "description", "The directory that the launcher should be run from.",
            "help", "If not set, it will be run without setting an explicit working directory, which is usually sufficient.",
            "storageKey", this.configPrefix . "WorkingDir",
            "group", "locations",
            "modes", Map(
                "simple", Map("formField", false)
            )
        )

        ; - Shortcut (Run a shortcut file)
        ; - Command (Run a command directly, the default if required)
        definitions["RunType"] := Map(
            "description", "Which method to use for launching this item.",
            "help", "This is only needed for launchers that have to manage their own process.",
            "storageKey", this.configPrefix . "RunType",
            "default", "Command",
            "group", "process",
            "widget", "select",
            "selectOptionsCallback", ObjBindMethod(this, "ListRunTypes")
        )

        definitions["UsesShortcut"] := Map(
            "type", "boolean",
            "description", "Whether a shortcut file will be used when starting the internally-managed game launcher",
            "formField", false,
            "storageKey", this.configPrefix . "UsesShortcut"
        )

        definitions["ReplaceProcess"] := Map(
            "type", "boolean",
            "description", "Kill and re-launch the game process immediately after it is detected.",
            "help", "This can be used to force Launchpad to own the game process, but won't for for every game.",
            "storageKey", this.configPrefix . "ReplaceProcess",
            "default", false,
            "group", "process"
        )

        ; - The filename of an existing shortcut (.url or .lnk file, or even another .exe) that will be used to run the game.
        ; - The path of another shortcut file (.url or .lnk) on the system, which will be copied to the AssetsDir if it doesn't already exist
        ; - The path of an .exe file on the system to which a shortcut will be created in AssetsDir if it doesn't already exist. Using this option
        ;   is usually not necessary, since you can run the .exe directly instead.
        definitions["ShortcutSrc"] := Map(
            "description", "The shortcut file used to launch the game launcher itself.",
            "help", "This is typically only needed if the Shortcut LauncherRunType is selected.",
            "storageKey", this.configPrefix . "ShortcutSrc",
            "group", "locations",
            "modes", Map(
                "simple", Map("group", "general")
            )
        )

        ; - RunWait (the default, uses RunWait to both run a process and wait until it completes in one step. This is most efficient if it works.)
        ; - Run (Uses Run, then watches for the game window and waits until the window opens (if needed) and then closes)
        ; - Scheduled (Creates an immediate scheduled task that runs the game, then waits until the window opens (if needed) and then closes)
        definitions["RunMethod"] := Map(
            "description", "Which method to use to run the RunCmd",
            "storageKey", this.configPrefix . "RunMethod",
            "default", "Run",
            "group", "process",
            "widget", "select",
            "selectOptionsCallback", ObjBindMethod(this, "ListRunMethods")
        )

        ; - "Exe" (Waits for the game's .exe process to start if it hasn't already, and then waits for it to stop again. This is the default if the game type is not RunWait)
        ; - "Title" (Waits for the game's window title to open if it isn't already, and then waits for it to close again)
        ; - "Class" (Wait's for the game's window class to open if it isn't already, and then waits for it to close again)
        definitions["ProcessType"] := Map(
            "description", "Which method to use to wait for the game to close.",
            "help", "This is not needed if the GameRunType is RunWait",
            "storageKey", this.configPrefix . "ProcessType",
            "default", "Exe",
            "group", "process",
            "widget", "select",
            "selectOptionsCallback", ObjBindMethod(this, "ListProcessTypes")
        )

        ; - Exe - This value will default to the GameExe unless overridden
        ; - Title - This value will default to the game's Key unless overridden
        ; - Class - This value should be set to the game's window class
        definitions["ProcessId"] := Map(
            "help", "This value's type is dependent on the ProcessType above. It can often be detected from other values, and is not needed if the GameRunType is RunWait.",
            "storageKey", this.configPrefix . "ProcessId",
            "group", "process",
            "modes", Map(
                "simple", Map("formField", false)
            )
        )

        definitions["ProcessTimeout"] := Map(
            "description", "The number of seconds to wait before giving up when waiting for a process.",
            "storageKey", this.configPrefix . "ProcessTimeout",
            "default", 30,
            "group", "process",
            "modes", Map(
                "simple", Map("formField", false)
            )
        )

        definitions["RunCmd"] := Map(
            "description", "The command that will be used to run the game's launcher.",
            "help", "Typically only used if LauncherRunType is Command.",
            "storageKey", this.configPrefix . "RunCmd",
            "group", "process"
        )

        return definitions
    }

    GetData() {
        if (!this.ParentEntity) {
            throw EntityException("A parent entity is required on type " . Type(this))
        }

        return this.ParentEntity.GetData()
    }

    _createEntityData() {
        return ""
    }

    AutoDetectValues(recurse := true) {
        detectedValues := super.AutoDetectValues(recurse)
        processId := ""
        usesShortcut := false

        if (this.GetData().HasValue(this.configPrefix . "UsesShortcut")) {
            usesShortcut := this.GetData().GetValue(this.configPrefix . "UsesShortcut")
        } else {
            usesShortcut := (this["RunType"] == "Shortcut" || this["ShortcutSrc"] != "" || this["RunCmd"] == "")
        }

        detectedValues[this.configPrefix . "UsesShortcut"] := usesShortcut
        detectedValues[this.configPrefix . "RunType"] := usesShortcut ? "Shortcut" : "Command"
        detectedValues[this.configPrefix . "InstallDir"] := this.LocateInstallDir() ; This needs to run to expand exes without a dir

        if (this["ProcessType"] == "Exe") {
            SplitPath(this["Exe"], &processId)
        } else if (this["ProcessType"] == "Title") {
            processId := this["WindowTitle"] ? this["WindowTitle"] : this.Id
        }

        detectedValues[this.configPrefix . "ProcessId"] := processId
        detectedValues[this.configPrefix . "WorkingDir"] := this["InstallDir"]

        return detectedValues
    }

    ListRunTypes() {
        return [
            "Command",
            "Shortcut"
        ]
    }

    ListProcessTypes() {
        return [
            "Exe", "Title", "Class"
        ]
    }

    ListRunMethods() {
        return [
            "Run", "Scheduled", "RunWait"
        ]
    }

    ListLocateMethods() {
        return [
            "Search", "Registry", "BlizzardProductDb"
        ]
    }

    ListRegViews() {
        regViews := [
            "32"
        ]

        if (A_Is64bitOS) {
            regViews.Push("64")
        }

        return regViews
    }

    Validate() {
        validateResult := super.Validate()

        if (((this["UsesShortcut"] && this["RunCmd"] == "") && this["ShortcutSrc"] == "") && !this.ShortcutFileExists()) {
            validateResult["success"] := false
            validateResult["invalidFields"].push("ShortcutSrc")
        }

        if (this["ShortcutSrc"] == "" && this["RunCmd"] == "") {
            validateResult["success"] := false
            validateResult["invalidFields"].push("RunCmd")
        }

        ; TODO: Perform more launcher and game type validation here

        return validateResult
    }

    ShortcutFileExists() {
        shortcutSrc := (this["ShortcutSrc"] != "") 
            ? this["ShortcutSrc"] 
            : this["AssetsDir"] . "\" . this.Id . ".lnk"

        exists := FileExist(shortcutSrc)

        if (!exists) {
            shortcutSrc := this["AssetsDir"] . "\" . this.Id . ".url"
            exists := FileExist(shortcutSrc)
        }

        return exists
    }

    LocateInstallDir() {
        installDir := ""

        ; TODO: Add additional methods to detect the install dir

        if (this["LocateMethod"] == "BlizzardProductDb") {
            blizzardDir := this.GetBlizzardProductDir()

            if (blizzardDir != "") {
                installDir := blizzardDir
            }
        }

        return installDir
    }

    LocateExe() {
        return this.LocateFile(this["Exe"])
    }

    LocateFile(filePattern) {
        filePath := ""

        if (filePattern != "") {
            SplitPath(filePattern,,,,, &fileDrive)
            
            if (fileDrive != "") {
                filePath := filePattern
            } else {
                searchDirs := []

                if (this["InstallDir"] != "") {
                    searchDirs.Push(this["InstallDir"])
                } else if (this["LocateMethod"] == "SearchDirs") {
                    if (HasBase(this["SearchDirs"], Array.Prototype) && this["SearchDirs"].Length > 0) {
                        for index, dir in this["SearchDirs"] {
                            searchDirs.Push(dir)
                        }
                    }
                } else if (this["LocateMethod"] == "Registry") {
                    regKey := this["LocateRegKey"]

                    if (regKey != "") {
                        SetRegView(this["LocateRegView"])
                        regDir := RegRead(this["LocateRegKey"], this["LocateRegValue"])
                        SetRegView("Default")

                        if (regDir != "") {
                            if (this["LocateRegStripQuotes"]) {
                                regDir := StrReplace(regDir, "`"", "")
                            }

                            if (this["LocateRegRemovePrefix"] && SubStr(regDir, 1, StrLen(this["LocateRegRemovePrefix"])) == this["LocateRegRemovePrefix"]) {
                                regDir := SubStr(regDir, StrLen(this["LocateRegRemovePrefix"]) + 1)
                            }

                            if (this["LocateRegRemoveSuffix"] && SubStr(regDir, 1, StrLen(this["LocateRegRemoveSuffix"])) == this["LocateRegRemoveSuffix"]) {
                                regDir := StrReplace(regDir, StrLen(this["LocateRegRemoveSuffix"]) + 1)
                            }
                            
                            searchDirs.Push(regDir)
                        }
                    }
                } else if (this["LocateMethod"] == "BlizzardProductDb") {
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
            searchDirs := this["SearchDirs"].Clone()
        }

        if (!HasBase(searchDirs, Array.Prototype)) {
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
        productCode := this.GetBlizzardProductKey()

        if (productCode != "" && this.app.Services.Has("BlizzardProductDb")) {
            path := this.app["BlizzardProductDb"].GetProductInstallPath(productCode)
        }

        return path
    }
}
