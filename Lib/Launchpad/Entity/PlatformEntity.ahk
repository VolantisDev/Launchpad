class PlatformEntity extends FieldableEntity {
    platformObj := ""

    Platform {
        get => this.GetPlatform()
        set => this.platformObj := value
    }

    BaseFieldDefinitions() {
        definitions := super.BaseFieldDefinitions()

        definitions["PlatformClass"] := Map(
            "type", "class_name",
            "description", "The class name that will be instantiated to manage this platform.",
            "required", true,
            "formField", true,
            "editable", false,
            "default", "BasicPlatform"
        )

        definitions["IsEnabled"] := Map(
            "type", "boolean",
            "description", "Include this platform in operations which affect all platforms.",
            "default", true
        )

        definitions["IsInstalled"] := Map(
            "type", "boolean",
            "description", "Indicates whether this platform is currently installed.",
            "editable", false,
            "default", false
        )

        definitions["DetectGames"] := Map(
            "type", "boolean",
            "description", "Whether or not to include this platform when detecting installed games.",
            "default", false,
        )

        definitions["InstalledVersion"] := Map(
            "description", "The version of the platform that is currently detected on your machine.",
            "editable", false
        )

        definitions["InstallDir"] := Map(
            "type", "directory",
            "description", "The directory this platform is installed to.",
        )

        definitions["ExePath"] := Map(
            "type", "file",
            "fileMask", "*.exe",
            "description", "The path to this platform's primary executable file.",
        )

        definitions["IconSrc"] := Map(
            "type", "icon_file",
            "description", "The path to this platform's icon (.ico or .exe).",
        )

        definitions["UninstallCmd"] := Map(
            "description", "The command that will be run if you choose to uninstall this platform.",
            "formField", false,
            "editable", false
        )

        return definitions
    }

    GetPlatform() {
        if (!this.platformObj) {
            this.CreatePlatform()
        }

        return this.platformObj
    }

    CreatePlatform(platformClass := "") {
        if (platformClass == "") {
            platformClass := this["PlatformClass"]
        }

        if (platformClass) {
            this.platformObj := %platformClass%(this.app, this["InstallDir"], this["ExePath"], this["InstalledVersion"], this["UninstallCmd"])
        } else {
            throw EntityException("Cannot determine platform class.")
        }
    }

    GetName() {
        name := ""

        if (this.Platform and this.Platform.Name) {
            name := this.Platform.Name
        }

        return name
    }

    SetConfigValue(key, value, usePrefix := true) {
        super.SetConfigValue(key, value, usePrefix)
        this.CreatePlatform()
    }

    CheckForUpdates() {
        if (!this.Platform.IsInstalled() || this.Platform.NeedsUpdate()) {
            this.Platform.Install()
        }
    }

    GetLibraryDirs() {
        return this.Platform.GetLibraryDirs()
    }

    DetectInstalledGames() {
        return this.Platform.DetectInstalledGames()
    }

    Install() {
        this.Platform.Install()
    }

    Update() {
        this.Platform.Update()
    }

    Uninstall() {
        this.Platform.Uninstall()
    }

    Run() {
        if (this.Platform.IsInstalled()) {
            this.Platform.Run()
        }
    }

    AutoDetectValues(recurse := true) {
        detectedValues := super.AutoDetectValues(recurse)
        detectedValues["IsInstalled"] := this.Platform.IsInstalled()
        detectedValues["InstalledVersion"] := this.Platform.GetInstalledVersion()
        detectedValues["InstallDir"] := this.Platform.GetInstallDir()
        detectedValues["ExePath"] := this.Platform.GetExePath()
        detectedValues["IconSrc"] := detectedValues["ExePath"]
        detectedValues["UninstallCmd"] := this.Platform.GetUninstallCmd()

        return detectedValues
    }
}
