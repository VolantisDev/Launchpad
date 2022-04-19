class PlatformEntity extends AppEntityBase {
    platform := ""
    configPrefix := ""
    dataSourcePath := "platforms"

    SetupEntity() {
        super.SetupEntity()

        if (!this.platform) {
            this.CreatePlatform()
        }
    }

    BaseFieldDefinitions() {
        definitions := super.BaseFieldDefinitions()

        definitions["PlatformClass"] := Map(
            "type", "class_name",
            "description", "The class name that will be instantiated to manage this platform.",
            "required", true,
            "formField", false,
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

    CreatePlatform(platformClass := "") {
        if (platformClass == "") {
            platformClass := this["PlatformClass"]
        }

        if (platformClass) {
            this.platform := %platformClass%(this.app, this["InstallDir"], this["ExePath"], this["InstalledVersion"], this["UninstallCmd"])
        } else {
            throw EntityException("Cannot determine platform class.")
        }
    }

    GetName() {
        name := ""

        if (this.platform and this.platform.Name) {
            name := this.platform.Name
        }

        return name
    }

    SetConfigValue(key, value, usePrefix := true) {
        super.SetConfigValue(key, value, usePrefix)
        this.CreatePlatform()
    }

    CheckForUpdates() {
        if (!this.platform.IsInstalled() || this.platform.NeedsUpdate()) {
            this.platform.Install()
        }
    }

    GetLibraryDirs() {
        return this.platform.GetLibraryDirs()
    }

    DetectInstalledGames() {
        return this.platform.DetectInstalledGames()
    }

    Install() {
        this.platform.Install()
    }

    Update() {
        this.platform.Update()
    }

    Uninstall() {
        this.platform.Uninstall()
    }

    Run() {
        if (this.platform.IsInstalled()) {
            this.platform.Run()
        }
    }

    AutoDetectValues() {
        if (!this.platform) {
            this.CreatePlatform()
        }

        detectedValues := super.AutoDetectValues()
        detectedValues["IsInstalled"] := this.platform.IsInstalled()
        detectedValues["InstalledVersion"] := this.platform.GetInstalledVersion()
        detectedValues["InstallDir"] := this.platform.GetInstallDir()
        detectedValues["ExePath"] := this.platform.GetExePath()
        detectedValues["IconSrc"] := detectedValues["ExePath"]
        detectedValues["UninstallCmd"] := this.platform.GetUninstallCmd()
        return detectedValues
    }
}
