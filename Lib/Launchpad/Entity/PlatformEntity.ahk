class PlatformEntity extends AppEntityBase {
    platform := ""
    configPrefix := ""
    dataSourcePath := "platforms"

    PlatformClass {
        get => this.GetConfigValue("PlatformClass")
        set => this.SetConfigValue("PlatformClass", value)
    }
    
    IsEnabled {
        get => this.GetConfigValue("IsEnabled")
        set => this.SetConfigValue("IsEnabled", !!(value))
    }

    IsInstalled {
        get => this.GetConfigValue("IsInstalled")
        set => this.SetConfigValue("IsInstalled", !!(value))
    }

    DetectGames {
        get => this.GetConfigValue("DetectGames")
        set => this.SetConfigValue("DetectGames", !!(value))
    }

    InstalledVersion {
        get => this.GetConfigValue("InstalledVersion")
        set => this.SetConfigValue("InstalledVersion", value)
    }

    InstallDir {
        get => this.GetConfigValue("InstallDir")
        set => this.SetConfigValue("InstallDir", value)
    }

    ExePath {
        get => this.GetConfigValue("ExePath")
        set => this.SetConfigValue("ExePath", value)
    }

    IconSrc {
        get => this.GetConfigValue("IconSrc")
        set => this.SetConfigValue("IconSrc", value)
    }

    UninstallCmd {
        get => this.GetConfigValue("UninstallCmd")
        set => this.SetConfigValue("UninstallCmd", value)
    }

    __New(app, key, config, parentEntity := "", requiredConfigKeys := "") {
        if (requiredConfigKeys == "") {
            requiredConfigKeys := []
        }

        requiredConfigKeys.Push("PlatformClass")

        platformClass := config.Has("PlatformClass") ? config["PlatformClass"] : ""
        
        if (!platformClass) {
            throw OperationFailedException("Platform class could not be determined.")
        }

        super.__New(app, key, config, parentEntity, requiredConfigKeys)

        if (!this.platform) {
            this.CreatePlatform(platformClass)
        }
    }

    CreatePlatform(platformClass := "") {
        if (platformClass == "") {
            platformClass := this.PlatformClass
        }

        this.platform := %platformClass%(this.app, this.InstallDir, this.ExePath, this.InstalledVersion, this.UninstallCmd)
    }

    GetDisplayName() {
        name := ""

        if (this.platform and this.platform.displayName) {
            name := this.platform.displayName
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

    InitializeDefaults() {
        defaults := super.InitializeDefaults()
        defaults["PlatformClass"] := ""
        defaults["IsEnabled"] := true
        defaults["DetectGames"] := false
        defaults["IsInstalled"] := false
        defaults["InstalledVersion"] := ""
        defaults["InstallDir"] := ""
        defaults["ExePath"] := ""
        defaults["IconSrc"] := ""
        defaults["UninstallCmd"] := ""
        return defaults
    }

    LaunchEditWindow(mode, owner := "", parent := "") {
        return this.app.Service("GuiManager").Form("PlatformEditor", this, mode, owner, parent)
    }
}
