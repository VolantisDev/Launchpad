class LauncherEntity extends AppEntityBase {
    dataSourcePath := "games"
    configPrefix := "Launcher"
    additionalManagedLauncherDefaults := Map()

    IsBuilt {
        get => this.LauncherExists(false)
    }

    IsOutdated {
        get => !this.LauncherExists(false) or this.LauncherIsOutdated()
    }

    GetDefaultFieldGroups() {
        groups := super.GetDefaultFieldGroups()

        groups["ui"] := Map(
            "name", "UI",
            "weight", 50
        )

        groups["overlay"] := Map(
            "name", "Overlay",
            "weight", 60
        )

        groups["tasks"] := Map(
            "name", "Tasks",
            "weight", 80
        )

        return groups
    }

    BaseFieldDefinitions() {
        definitions := super.BaseFieldDefinitions()

        definitions["id"]["formField"] := false

        if (!definitions["id"].Has("modes")) {
            definitions["id"]["modes"] := Map()
        }

        if (!definitions["id"]["modes"].Has("wizard")) {
            definitions["id"]["modes"]["wizard"] := Map()
        }

        definitions["id"]["modes"]["wizard"]["formField"] := true
        definitions["id"]["modes"]["wizard"]["widget"] := "combo"
        definitions["id"]["modes"]["wizard"]["selectOptionsCallback"] := ObjBindMethod(this, "ListKnownGames")
        definitions["id"]["modes"]["wizard"]["description"] := "Select an existing game from the API, or enter a custom game key to create your own."

        definitions["name"]["description"] := "You can change the display name of the game if it differs from the key."
        definitions["name"]["help"] := "The launcher filename will still be created using the key."

        if (definitions.Has("DataSourceItemKey")) {
            definitions["DataSourceItemKey"]["default"] := ""
            definitions["DataSourceItemKey"]["description"] := "The key to use when looking this item up in its data source(s)."
            definitions["DataSourceItemKey"]["help"] := "By default, this is the same as the main key."
        }

        definitions["Platform"] := Map(
            "type", "entity_reference",
            "entityType", "platform",
            "required", true,
            "weight", -50,
            "refreshDataOnChange", true,
            "showDefaultCheckbox", false
        )

        definitions["ManagedLauncher"] := Map(
            "type", "entity_reference",
            "required", true,
            "entityType", "managed_launcher",
            "child", true,
            "weight", -25,
            "widget", "entity_select",
            "selectButton", true,
            "selectConditions", FieldCondition(MatchesCondition(this.Id), "id"),
            "description", "This tells " . this.app.appName . " how to interact with any launcher your game might require.",
            "help", "If your game's launcher isn't listed, or your game doesn't have a launcher, start with Default.",
            "refreshDataOnChange", true,
            "modes", Map(
                "simple", Map(
                    "entityFormMode", "simple"
                )
            ),
            "default", this.idVal,
            "showDefaultCheckbox", false,
            "valueType", EntityFieldBase.VALUE_TYPE_DEFAULT
        )

        definitions["ManagedGame"] := Map(
            "type", "entity_reference",
            "required", true,
            "entityType", "managed_game",
            "child", true,
            "weight", -20,
            "widget", "entity_select",
            "selectButton", true,
            "selectConditions", FieldCondition(MatchesCondition(this.Id), "id"),
            "refreshDataOnChange", true,
            "description", "This tells " . this.app.appName . " how to launch your game.",
            "help", "Most games can use 'default', but launchers can support different game types.",
            "modes", Map(
                "simple", Map(
                    "entityFormMode", "simple"
                )
            ),
            "default", this.idVal,
            "showDefaultCheckbox", false,
            "valueType", EntityFieldBase.VALUE_TYPE_DEFAULT
        )

        definitions["DestinationDir"] := Map(
            "type", "directory",
            "required", true,
            "default", this.GetDefaultDestinationDir(),
            "modes", Map(
                "simple", Map("formField", false)
            )
        )

        ; The icon file that the launcher will use. This can be one of several types of values:
        ; - The filename of an existing icon in the AssetsDir
        ; - The path of another icon file on the system, which will be copied to the AssetsDir if it doesn't already exist
        ; - The path of an .exe file on the system where the icon will be extracted from and saved to the assets directory if it doesn't already exist
        ; - "" (empty string) - Auto detection. See below.
        ; 
        ; Auto detection rules if IconSrc is not set:
        ; 1. Look for [Key].ico in the assets directory
        ; 2. If GameExe is an absolute path, use GameExe's path as the IconSrc
        ; 3. If GameExe is a filename, search for that filename in GameDirs and use its path as the IconSrc if found
        ; 3. Prompt for an icon during validation if the path is still not set
        definitions["IconSrc"] := Map(
            "type", "icon_file",
            "description", "The path to this an icon (.ico or .exe).",
            "modes", Map(
                "simple", Map("formField", false)
            )
        )

        definitions["Theme"] := Map(
            "type", "service_reference",
            "servicePrefix", "theme.",
            "default", this.app.Config["theme_name"],
            "required", true,
            "group", "ui",
            "modes", Map(
                "simple", Map("formField", false)
            ),
            "description", "The theme to use if/when the launcher shows GUI windows."
        )

        definitions["ThemesDir"] := Map(
            "type", "directory",
            "required", true,
            "mustExist", true,
            "formField", false,
            "default", this.app.appDir . "\Resources\Themes",
            "group", "ui",
            "modes", Map(
                "simple", Map("formField", false)
            )
        )

        definitions["ResourcesDir"] := Map(
            "type", "directory",
            "required", true,
            "mustExist", true,
            "formField", false,
            "default", this.app.appDir . "\Resources",
            "modes", Map(
                "simple", Map("formField", false)
            )
        )

        definitions["ShowProgress"] := Map(
            "type", "boolean",
            "required", false,
            "default", true,
            "group", "ui",
            "modes", Map(
                "simple", Map("group", "general")
            ),
            "tooltip", "Whether or not to show a window indicating the current status of the launcher"
        )

        definitions["RunBefore"] := Map(
            "type", "entity_reference",
            "entityType", "task",
            "multiple", true,
            "group", "tasks",
            "modes", Map(
                "simple", Map("formField", false)
            ),
            "description", "Run one or more processes before launching the game.",
            "help", "Each line should contain a command to run or a full path to a .exe or shortcut file to launch.`n`nEach process will be run as a scheduled task so that it is not owned by the launcher."
        )

        definitions["CloseBefore"] := Map(
            "type", "entity_reference",
            "entityType", "task",
            "multiple", true,
            "group", "tasks",
            "modes", Map(
                "simple", Map("formField", false)
            ),
            "description", "Close one or more processes before launching the game.",
            "help", "Each line should contain the name of the process to close (usually just the .exe filename)."
        )

        definitions["RunAfter"] := Map(
            "type", "entity_reference",
            "entityType", "task",
            "multiple", true,
            "group", "tasks",
            "modes", Map(
                "simple", Map("formField", false)
            ),
            "description", "Run one or more processes after closing the game.",
            "help", "Each line should contain a command to run or a full path to a .exe or shortcut file to launch.`n`nEach process will be run as a scheduled task so that it is not owned by the launcher."
        )

        definitions["CloseAfter"] := Map(
            "type", "entity_reference",
            "entityType", "task",
            "multiple", true,
            "group", "tasks",
            "modes", Map(
                "simple", Map("formField", false)
            ),
            "description", "Close one or more processes after closing the game.",
            "help", "Each line should contain the name of the process to close (usually just the .exe filename)."
        )

        definitions["LogPath"] := Map(
            "type", "file",
            "default", this.app.tmpDir . "\Logs\" . this.Id . ".txt",
            "group", "advanced",
            "modes", Map(
                "simple", Map("formField", false)
            )
        )

        definitions["LoggingLevel"] := Map(
            "widget", "select",
            "selectOptionsCallback", ObjBindMethod(this.container.Get("logger"), "GetLogLevels"),
            "default", this.app.Config["logging_level"],
            "group", "advanced",
            "modes", Map(
                "simple", Map("formField", false)
            )
        )

        definitions["EnableOverlay"] := Map(
            "type", "boolean",
            "default", false,
            "group", "overlay",
            "modes", Map(
                "simple", Map("group", "general")
            ),
            "help", "Enabling this option makes the Steam Overlay work with any application that's otherwise incompatible with it. You must use Borderless Fullscreen instead of true Fullscreen when using this option to allow the Launchpad Overlay to display over the game window. If the Steam Overlay is already detected, then the Launchpad Overlay won't be used."
        )

        definitions["ForceOverlay"] := Map(
            "type", "boolean",
            "default", false,
            "group", "overlay",
            "modes", Map(
                "simple", Map("formField", false)
            ),
            "help", "Enabling this option along with the Launchpad Overlay means the Launchpad Overlay will always be used, instead of it waiting to see if the Steam Overlay is attached first."
        )

        definitions["OverlayHotkey"] := Map(
            "type", "hotkey",
            "default", "^Tab",
            "group", "overlay",
            "modes", Map(
                "simple", Map("formField", false)
            ),
            "description", "The AHK-compatible hotkey definition that will open and close the Launchpad Overlay"
        )

        definitions["OverlayWait"] := Map(
            "type", "time_offset",
            "timeUnits", "s",
            "default", 10,
            "group", "overlay",
            "modes", Map(
                "simple", Map("formField", false)
            ),
            "description", "How many seconds to wait for the Steam overlay to attach before starting the Launchpad Overlay.",
            "help", "If the Steam Overlay attaches within this time, and the Force option is not active, then the Launchpad Overlay will not be used."
        )

        return definitions
    }

    /**
    * NEW METHODS
    */
    LauncherExists(checkSourceFile := false) {
        return (FileExist(this.GetLauncherFile(this.Id, checkSourceFile)) != "")
    }

    ListKnownGames() {
        return this.container
            .Get("manager.data_source")
            .GetDefaultDataSource()
            .ReadListing("game-keys")
    }

    LauncherIsOutdated() {
        outdated := true

        filePath := this.GetLauncherFile(this.Id)

        if (filePath && FileExist(filePath)) {
            launcherVersion := FileGetVersion(this.GetLauncherFile(this.Id))

            if (launcherVersion && !this.app.Service("version_checker").VersionIsOutdated(this.app.Version, launcherVersion)) {
                outdated := false
            }

            configInfo := this.app.State.GetLauncherInfo(this.Id, "Config")
            buildInfo := this.app.State.GetLauncherInfo(this.Id, "Build")

            if (!buildInfo["Version"] || !buildInfo["Timestamp"]) {
                outdated := true
            } else {
                if (configInfo["Version"] && this.app.Service("version_checker").VersionIsOutdated(configInfo["Version"], buildInfo["Version"])) {
                    outdated := true
                } else if (configInfo["Timestamp"] && DateDiff(configInfo["Timestamp"], buildInfo["Timestamp"], "S") > 0) {
                    outdated := true
                }
            }
        }

        return outdated
    }

    GetLauncherFile(key, checkSourceFile := false) {
        gameDir := checkSourceFile ? this.app.Config["assets_dir"] : this.app.Config["destination_dir"]

        if (checkSourceFile) {
            gameDir .= "\" . key
        }

        ext := checkSourceFile ? ".ahk" : ".exe"
        return gameDir . "\" . key . ext
    }

    GetStatus() {
        status := "Missing"

        if (this.LauncherExists()) {
            status := this.IsOutdated ? "Outdated" : "Ready"
        }

        return status
    }

    /**
    * OVERRIDES
    */

    Validate() {
        validateResult := super.Validate()

        if (this["IconSrc"] == "" && !this.IconFileExists()) {
            validateResult["success"] := false
            validateREsult["invalidFields"].push("IconSrc")
        }

        ; TODO: Validate launcher entities here

        return ValidateResult
    }

    SaveModifiedData() {
        super.SaveModifiedData()
        this.app.State.SetLauncherConfigInfo(this.Id)
    }

    GetDataSourceItemKey() {
        if (!this["DataSourceItemKey"]) {
            dataSources := this.GetAllDataSources()

            for index, dataSource in dataSources {
                platform := this["Platform"] ? this["Platform"]["id"] : ""
                apiPath := "lookup/" this.Id

                if (platform) {
                    apiPath .= "/" . platform
                }
                
                dsData := dataSource.ReadJson(apiPath)

                if (dsData != "" && dsData.Has("id") && dsData["id"]) {
                    this["DataSourceItemKey"] := dsData["id"]
                    break
                }
            }
        }

        if (this["DataSourceItemKey"]) {
            return this["DataSourceItemKey"]
        } else {
            return ""
        }
    }

    IconFileExists() {
        iconSrc := this["IconSrc"] != "" ? this["IconSrc"] : this.GetAssetPath(this.Id . ".ico")
        return FileExist(iconSrc)
    }

    MergeAdditionalDataSourceDefaults(defaults, dataSourceData) {
        launcherType := this.DetectLauncherType(defaults, dataSourceData)

        checkType := (launcherType == "") ? "Default" : launcherType
        if (dataSourceData.Has("Launchers") && dataSourceData["Launchers"].Has(checkType) && HasBase(dataSourceData["Launchers"][checkType], Map.Prototype)) {
            this.additionalManagedLauncherDefaults := this.merger.Merge(dataSourceData["Launchers"][checkType], this.additionalManagedLauncherDefaults)
            defaults := this.merger.Merge(defaults, dataSourceData["Launchers"][checkType])
        }

        defaults["ManagedLauncher"] := launcherType
        
        return defaults
    }

    DetectLauncherType(defaults, dataSourceData := "") {
        launcherType := ""

        if (this.UnmergedFieldData.Has("LauncherType")) {
            launcherType := this.UnmergedFieldData["LauncherType"]
        } else if (defaults.Has("LauncherType")) {
            launcherType := defaults["LauncherType"]
        }

        if (launcherType == "") {
            launcherType := "Default"
        }

        if (dataSourceData != "" && dataSourceData.Has("Launchers")) {
            launcherType := this._dereferenceKey(launcherType, dataSourceData["Launchers"])
        }

        return launcherType
    }

    _dereferenceKey(key, map) {
        if (map.Has(key) && Type(map[key]) == "String") {
            key := this._dereferenceKey(map[key], map)
        }

        return key
    }

    AutoDetectValues() {
        detectedValues := super.AutoDetectValues()
        
        if (!detectedValues.Has("IconSrc")) {
            checkPath := this["AssetsDir"] . "\" . this.Id . ".ico"
            
            if (FileExist(checkPath)) {
                detectedValues["IconSrc"] := checkPath
            } else if (this.children.Has("ManagedLauncher") && this["ManagedGame"].GetConfigValue("Exe") != "") {
                detectedValues["IconSrc"] := this["ManagedGame"].LocateExe()
            } else {
                detectedValues["IconSrc"] := this.app.appDir . "\Resources\Graphics\Game.ico"
            }
        }

        defaultTheme := this.app.Config["default_launcher_theme"] ? 
            this.app.Config["default_launcher_theme"] : 
            this.app.Config["theme_name"]

        if (defaultTheme && this.app.Config["override_launcher_theme"]) {
            detectedValues["Theme"] := defaultTheme
        }

        return detectedValues
    }

    GetDefaultDestinationDir() {
        return this.app.Config["destination_dir"]
    }

    GetEditorButtons(mode) {
        buttons := super.GetEditorButtons(mode)
        buttons .= mode == "simple" ? "|&Advanced" : "|S&imple"

        return buttons
    }
}
