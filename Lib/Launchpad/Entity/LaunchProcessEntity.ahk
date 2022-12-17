class LaunchProcessEntity extends FieldableEntity {
    defaultClass := "Default"

    DiscoverParentEntity(container, eventMgr, id, storageObj, idSanitizer, parentEntity := "") {
        ; TODO fix circular reference occurring

        return parentEntity
            ? parentEntity
            : container.Get("entity_manager.launcher")[id]
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

        definitions["ProcessClass"] := Map(
            "default", this.defaultClass,
            "description", "The name of the AHK class that will be used to control the process.",
            "formField", false,
            "required", true,
            "group", "advanced",
            "modes", Map(
                "simple", Map("formField", false)
            ),
        )

        definitions["SearchDirs"] := Map(
            "type", "directory",
            "mustExist", false,
            "default", [A_ProgramFiles],
            "description", "Possible parent directories where the game's launcher might exist, to be used for auto-detection.",
            "help", "These should be as specific as possible to reduce detection time.",
            "cardinality", 1, ; Change to another number once widgets for multiple values are worked out
            "group", "locations",
            "modes", Map(
                "simple", Map("formField", false)
            )
        )

        definitions["InstallDir"] := Map(
            "type", "directory",
            "mustExist", false,
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
            "group", "process"
        )

        definitions["LocateRegView"] := Map(
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
            "title", "Registry Locator - Key",
            "group", "registry",
            "description", "The registry key to look up the install dir within.",
            "help", "Path parts should be separated with backslashes and must start with one of: HKEY_LOCAL_MACHINE, HKEY_USERS, HKEY_CURRENT_USER, HKEY_CLASSES_ROOT, HKEY_CURRENT_CONFIG, or the abbreviation of one of those. To read from a remote registry, prefix the root path with two backslashes and the computer name.`n`nSimple example: HKLM\Path\To\Key`nRemote example: \\OTHERPC\HKLM\Path\To\Key",
            "modes", Map(
                "simple", Map("formField", false)
            )
        )

        definitions["LocateRegValue"] := Map(
            "title", "Registry Locator - Value",
            "group", "registry",
            "description", "The name of the registry value to look up within the specified key.",
            "help", "Example: InstallPath",
            "modes", Map(
                "simple", Map("formField", false)
            )
        )

        definitions["LocateRegRemovePrefix"] := Map(
            "title", "Registry Locator - Remove Prefix",
            "group", "registry",
            "modes", Map(
                "simple", Map("formField", false)
            )
        )

        definitions["LocateRegRemoveSuffix"] := Map(
            "title", "Registry Locator - Remove Suffix",
            "group", "registry",
            "modes", Map(
                "simple", Map("formField", false)
            )
        )

        definitions["LocateRegStripQuotes"] := Map(
            "title", "Registry Locator - Strip Quotes",
            "default", false,
            "group", "registry",
            "description", "Strip quotes from registry value",
            "modes", Map(
                "simple", Map("formField", false)
            )
        )

        definitions["PlatformRef"] := Map(
            "title", "Platform Reference",
            "description", "If the item is known to the launcher by a specific ID, it should be stored here.",
            "group", "general"
        )

        definitions["WorkingDir"] := Map(
            "title", "Working Directory",
            "type", "directory",
            "description", "The directory that the launcher should be run from.",
            "help", "If not set, it will be run without setting an explicit working directory, which is usually sufficient.",
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
            "default", "Command",
            "group", "process",
            "widget", "select",
            "selectOptionsCallback", ObjBindMethod(this, "ListRunTypes")
        )

        definitions["UsesShortcut"] := Map(
            "type", "boolean",
            "description", "Whether a shortcut file will be used when starting the internally-managed game launcher",
            "formField", false
        )

        definitions["ReplaceProcess"] := Map(
            "type", "boolean",
            "description", "Kill and re-launch the game process immediately after it is detected.",
            "help", "This can be used to force Launchpad to own the game process, but won't for for every game.",
            "default", false,
            "group", "process"
        )

        ; - The filename of an existing shortcut (.url or .lnk file, or even another .exe) that will be used to run the game.
        ; - The path of another shortcut file (.url or .lnk) on the system, which will be copied to the AssetsDir if it doesn't already exist
        ; - The path of an .exe file on the system to which a shortcut will be created in AssetsDir if it doesn't already exist. Using this option
        ;   is usually not necessary, since you can run the .exe directly instead.
        definitions["ShortcutSrc"] := Map(
            "title", "Shortcut Source",
            "description", "The shortcut file used to launch the game launcher itself.",
            "help", "This is typically only needed if the Shortcut LauncherRunType is selected.",
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
            "group", "process",
            "modes", Map(
                "simple", Map("formField", false)
            )
        )

        definitions["ProcessTimeout"] := Map(
            "description", "The number of seconds to wait before giving up when waiting for a process.",
            "default", 30,
            "group", "process",
            "modes", Map(
                "simple", Map("formField", false)
            )
        )

        definitions["RunCmd"] := Map(
            "title", "Run Command",
            "description", "The command that will be used to run the game's launcher.",
            "help", "Typically only used if LauncherRunType is Command.",
            "group", "process"
        )

        return definitions
    }

    AutoDetectValues() {
        detectedValues := super.AutoDetectValues()
        processId := ""

        usesShortcut := (this.GetData().HasValue("UsesShortcut"))
            ? this.GetData().GetValue("UsesShortcut")
            : (this["RunType"] == "Shortcut" || this["ShortcutSrc"] != "" || this["RunCmd"] == "")

        detectedValues["UsesShortcut"] := usesShortcut
        detectedValues["RunType"] := usesShortcut ? "Shortcut" : "Command"
        detectedValues["InstallDir"] := this.LocateInstallDir() ; This needs to run to expand exes without a dir

        if (this["ProcessType"] == "Exe") {
            SplitPath(this["Exe"], &processId)
        } else if (this["ProcessType"] == "Title") {
            processId := this["WindowTitle"] ? this["WindowTitle"] : this.Id
        }

        detectedValues["ProcessId"] := processId
        detectedValues["WorkingDir"] := this["InstallDir"]

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
            "Exe", 
            "Title", 
            "Class"
        ]
    }

    ListRunMethods() {
        return [
            "Run", 
            "Scheduled", 
            "RunWait"
        ]
    }

    ListLocateMethods() {
        return [
            "Search", 
            "Registry", 
            "BlizzardProductDb" ; TODO Move this to the Blizzard module
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

        ; TODO: Perform more validation here

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

        ; TODO Move BlizzardProductDb method to an event handled by the Blizzard module
        if (this["LocateMethod"] == "BlizzardProductDb") {
            blizzardDir := this.GetBlizzardProductDir()

            if (blizzardDir != "") {
                installDir := blizzardDir
            }
        }

        ; TODO: Add additional methods to detect the install dir

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
                    ; TODO Move BlizzardProductDb method to an event handled by the Blizzard module
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

    ; TODO Move this method to the Blizzard module and call it from an eevent
    GetBlizzardProductDir() {
        productCode (HasBase(this, GameProcessEntity.Prototype))
            ? productCode := this["PlatformRef"]
            : "bna" ; Default to the Battle.net client itself

        return (productCode != "" && this.app.Services.Has("BlizzardProductDb"))
            ? this.app["BlizzardProductDb"].GetProductInstallPath(productCode)
            : ""
    }
}
