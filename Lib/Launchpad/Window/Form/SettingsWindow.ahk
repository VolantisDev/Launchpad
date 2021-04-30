class SettingsWindow extends FormGuiBase {
    availableThemes := Map()
    logLevels := ["None", "Error", "Warning", "Info", "Debug"]
    listViewModes := ["Report", "Tile", "List"]
    doubleClickActions := ["Edit", "Run"]
    needsRestart := false

    __New(app, themeObj, windowKey, owner := "", parent := "") {
        if (owner == "") {
            owner := "MainWindow"
        }

        this.availableThemes := app.Service("ThemeManager").GetAvailableThemes(true)
        super.__New(app, themeObj, windowKey, "Settings", "", owner, parent, "*&Done")
    }

    Controls() {
        super.Controls()
        buttonSize := this.themeObj.GetButtonSize("s", true)
        buttonW := (buttonSize.Has("w") && buttonSize["w"] != "auto") ? buttonSize["w"] : 80
        ctl := this.Add("TabsControl", "vSettingsTabs", "", ["Launchers", "Platforms", "Backups", "Appearance", "Cache", "Advanced"])
        tabs := ctl.ctl

        tabs.UseTab("Launchers", true)

        this.AddHeading("Double-Click Action")
        chosen := this.GetItemIndex(this.doubleClickActions, this.app.Config.LauncherDoubleClickAction)
        ctl := this.guiObj.AddDDL("vLauncherDoubleClickAction xs y+m Choose" . chosen . " w250 c" . this.themeObj.GetColor("editText"), this.doubleClickActions)
        ctl.OnEvent("Change", "OnLauncherDoubleClickActionChange")
        ctl.ToolTip := "Select what you would like to happen when double-clicking a launcher in the main list."

        this.AddConfigLocationBlock("Launcher File", "LauncherFile", "Reload")
        this.AddConfigLocationBlock("Launcher Directory", "DestinationDir")
        this.AddConfigLocationBlock("Assets Directory", "AssetsDir")

        this.AddHeading("Launcher Settings")
        this.AddConfigCheckBox("Create desktop shortcuts for launchers", "CreateDesktopShortcuts")
        this.AddConfigCheckBox("Rebuild existing launchers when building all launchers", "RebuildExistingLaunchers")
        this.AddConfigCheckBox("Use advanced launcher editor by default", "UseAdvancedLauncherEditor")
        this.AddConfigCheckBox("Clean launchers automatically when building", "CleanLaunchersOnBuild")
        this.AddConfigCheckBox("Clean launchers automatically when exiting Launchpad", "CleanLaunchersOnExit")

        tabs.UseTab("Platforms", true)

        this.Add("ButtonControl", "", "Manage Platforms", "OnManagePlatforms")

        this.AddHeading("Platforms View Mode")
        chosen := this.GetItemIndex(this.listViewModes, this.app.Config.PlatformsViewMode)
        ctl := this.guiObj.AddDDL("vPlatformsViewMode xs y+m Choose" . chosen . " w250 c" . this.themeObj.GetColor("editText"), this.listViewModes)
        ctl.OnEvent("Change", "OnPlatformsViewModeChange")
        ctl.ToolTip := "Select how you would like to view your platforms in the Platform Manager."

        this.AddConfigLocationBlock("Platforms File", "PlatformsFile", "Reload")

        tabs.UseTab("Backups")

        this.Add("ButtonControl", "", "Manage Backups", "OnManageBackups")

        this.AddHeading("Backups View Mode")
        chosen := this.GetItemIndex(this.listViewModes, this.app.Config.BackupsViewMode)
        ctl := this.guiObj.AddDDL("vBackupsViewMode xs y+m Choose" . chosen . " w250 c" . this.themeObj.GetColor("editText"), this.listViewModes)
        ctl.OnEvent("Change", "OnBackupsViewModeChange")
        ctl.ToolTip := "Select how you would like to view your backups in the Backup Manager."

        this.AddConfigLocationBlock("Backup Dir", "BackupDir", "&Manage")
        this.AddConfigLocationBlock("Backups File", "BackupsFile")

        this.AddHeading("Backups to Keep")
        ctl := this.AddEdit("BackupsToKeep", this.app.Config.BackupsToKeep, "y+" . this.margin, 100)
        ctl.OnEvent("Change", "OnBackupsToKeepChange")
        this.guiObj.AddText("w" . this.windowSettings["contentWidth"] " y+" . this.margin, "Note: This can be overridden for individual backups in the Backup Manager.")

        this.AddHeading("Backup Options")
        this.AddConfigCheckbox("Automatically back up config files", "AutoBackupConfigFiles")

        tabs.UseTab("Appearance", true)

        this.AddHeading("Launchpad Theme")
        chosen := this.GetItemIndex(this.availableThemes, this.app.Config.ThemeName)
        ctl := this.guiObj.AddDDL("vThemeName xs y+m Choose" . chosen . " w250 c" . this.themeObj.GetColor("editText"), this.availableThemes)
        ctl.OnEvent("Change", "OnThemeNameChange")
        ctl.ToolTip := "Select a theme for Launchpad to use."

        this.Add("ButtonControl", "", "Reload Launchpad", "OnReload")

        this.AddHeading("Default Launcher Theme")
        chosen := this.GetItemIndex(this.availableThemes, this.app.Config.DefaultLauncherTheme)
        ctl := this.guiObj.AddDDL("vDefaultLauncherTheme xs y+m Choose" . chosen . " w250 c" . this.themeObj.GetColor("editText"), this.availableThemes)
        ctl.OnEvent("Change", "OnDefaultLauncherThemeChange")
        ctl.ToolTip := "Select the theme your launchers will use unless overridden."

        this.AddConfigCheckBox("Override API launcher themes with the default theme", "OverrideLauncherTheme")

        tabs.UseTab("Cache", true)

        this.AddConfigLocationBlock("Cache Dir", "CacheDir", "&Flush")

        this.AddHeading("Cache Settings")
        this.AddConfigCheckBox("Flush cache on exit (Recommended only for debugging)", "FlushCacheOnExit")

        tabs.UseTab("Advanced", true)

        this.AddHeading("Updates")
        this.AddConfigCheckBox("Check for updates on start", "CheckUpdatesOnStart")

        this.AddHeading("Logging Level")
        chosen := this.GetItemIndex(this.logLevels, this.app.Config.LoggingLevel)
        ctl := this.guiObj.AddDDL("vLoggingLevel xs y+m Choose" . chosen . " w200 c" . this.themeObj.GetColor("editText"), this.logLevels)
        ctl.OnEvent("Change", "OnLoggingLevelChange")

        this.AddConfigLocationBlock("API Endpoint", "ApiEndpoint")

        this.AddHeading("API Settings")
        ctl := this.AddConfigCheckBox("Enable API login for enhanced functionality", "ApiAuthentication")
        ctl.ctl.NeedsRestart := true
        ctl := this.AddConfigCheckBox("Automatically initiate API login when needed", "ApiAutoLogin")
        ctl.ctl.NeedsRestart := true

        tabs.UseTab()

        closeW := 100
        closeX := this.margin + this.windowSettings["contentWidth"] - closeW
    }

    OnManageBackups(btn, info) {
        this.app.Service("GuiManager").OpenWindow("ManageBackupsWindow")
    }

    OnManagePlatforms(btn, info) {
        this.app.Service("GuiManager").OpenWindow("PlatformsWindow")
    }

    AddConfigLocationBlock(heading, settingName, extraButton := "", helpText := "") {
        location := this.app.Config.%settingName% ? this.app.Config.%settingName% : "Not selected"
        return this.Add("LocationBlock", "", heading, location, settingName, extraButton, true, helpText)
    }

    AddConfigCheckbox(checkboxText, settingName) {
        isChecked := this.app.Config.%settingName%
        opts := ["v" . settingName, "w" . this.windowSettings["contentWidth"], "Checked" . isChecked]
        ctl := this.Add("BasicControl", opts, "", "", "CheckBox", checkboxText)
        ctl.RegisterHandler("Click", "OnSettingsCheckbox")
        return ctl
    }

    OnSettingsCheckbox(chk, info) {
        this.guiObj.Submit(false)
        ctlName := chk.Name
        this.app.Config.%ctlName% := chk.Value

        if (chk.HasProp("NeedsRestart") && chk.NeedsRestart) {
            this.needsRestart := true
        }
    }

    AddSettingsButton(buttonLabel, ctlName, width := "", height := "", position := "xs y+m", buttonStyle := "normal") {
        buttonSize := this.themeObj.GetButtonSize("s", true)

        if (width == "") {
            width := (buttonSize.Has("w") && buttonSize["w"] != "auto") ? buttonSize["w"] : 80
        }

        if (height == "") {
            height := (buttonSize.Has("h") && buttonSize["h"] != "auto") ? buttonSize["h"] : 20
        }

        return this.Add("ButtonControl", "v" . ctlName . " " . position . " w" . width . " h" . height, buttonLabel, "", buttonStyle)
    }

    SetText(ctlName, ctlText, fontStyle := "") {
        this.guiObj.SetFont(fontStyle)
        this.guiObj[ctlName].Text := ctlText
        this.SetFont()
    }

    OnLauncherFileMenuClick(btn) {
        if (btn == "ChangeLauncherFile") {
            this.app.Config.ChangeLauncherFile()
            this.SetText("LauncherFile", this.app.Config.LauncherFile, "Bold")
        } else if (btn == "OpenLauncherFile") {
            this.app.Config.OpenLauncherFile()
        } else if (btn == "ReloadLauncherFile") {
            this.app.Service("LauncherManager").ReloadLauncherFile()
        }
    }

    OnBackupsFileMenuClick(btn) {
        if (btn == "ChangeBackupsFile") {
            this.app.Config.ChangeBackupsFile()
            this.SetText("BackupsFile", this.app.Config.LauncherFile, "Bold")
        } else if (btn == "OpenBackupsFile") {
            this.app.Config.OpenBackupsFile()
        } else if (btn == "ReloadBackupsFile") {
            this.app.Service("LauncherManager").ReloadBackupsFile()
        }
    }

    OnPlatformsFileMenuClick(btn) {
        if (btn == "ChangePlatformsFile") {
            this.app.Config.ChangePlatformsFile()
            this.SetText("PlatformsFile", this.app.Config.PlatformsFile, "Bold")
        } else if (btn == "OpenPlatformsFile") {
            this.app.Config.OpenPlatformsFile()
        } else if (btn == "ReloadPlatformsFile") {
            this.app.Service("PlatformManager").ReloadPlatformsFile()
        }
    }

    OnDestinationDirMenuClick(btn) {
        if (btn == "ChangeDestinationDir") {
            this.app.Config.ChangeDestinationDir()
            this.SetText("DestinationDir", this.app.Config.DestinationDir, "Bold")
            this.needsRestart := true
        } else if (btn == "OpenDestinationDir") {
            this.app.Config.OpenDestinationDir()
        }
    }

    OnApiTokenChange(ctl, info) {
        this.guiObj.Submit(false)
        this.needsRestart := true
        this.app.Config.ApiToken := ctl.Text
    }

    OnAssetsDirMenuClick(btn) {
        if (btn == "ChangeAssetsDir") {
            this.app.Config.ChangeAssetsDir()
            this.SetText("AssetsDir", this.app.Config.AssetsDir, "Bold")
            this.needsRestart := true
        } else if (btn == "OpenAssetsDir") {
            this.app.Config.OpenAssetsDir()
        }
    }

    OnApiEndpointMenuClick(btn) {
        if (btn == "ChangeApiEndpoint") {
            this.app.Service("DataSourceManager").GetItem("api").ChangeApiEndpoint("", "")
            this.SetText("ApiEndpoint", this.app.Config.ApiEndpoint, "Bold")
            this.needsRestart := true
        } else if (btn == "OpenApiEndpoint") {
            this.app.Service("DataSourceManager").GetItem("api").Open()
        }
    }

    OnCacheDirMenuClick(btn) {
        if (btn == "ChangeCacheDir") {
            this.app.Service("CacheManager").ChangeCacheDir()
            this.SetText("CacheDir", this.app.Config.CacheDir, "Bold")
        } else if (btn == "OpenCacheDir") {
            this.app.Service("CacheManager").OpenCacheDir()
        } else if (btn == "FlushCacheDir") {
            this.app.Service("CacheManager").FlushCaches()
        }
    }

    OnBackupDirMenuClick(btn) {
        if (btn == "ChangeBackupDir") {
            this.app.Service("BackupManager").ChangeBackupDir()
            this.SetText("BackupDir", this.app.Config.BackupDir, "Bold")
            this.needsRestart := true
        } else if (btn == "OpenBackupDir") {
            this.app.Service("BackupManager").OpenBackupDir()
        }
    }

    OnThemeNameChange(ctl, info) {
        this.guiObj.Submit(false)
        this.app.Config.ThemeName := this.availableThemes[ctl.Value]
        this.app.Service("ThemeManager").LoadMainTheme()
        this.needsRestart := true
    }

    OnDefaultLauncherThemeChange(ctl, info) {
        this.guiObj.Submit(false)
        this.app.Config.DefaultLauncherTheme := this.availableThemes[ctl.Value]
    }

    OnPlatformsViewModeChange(ctl, info) {
        this.guiObj.Submit(false)
        this.app.Config.PlatformsViewMode := this.listViewModes[ctl.Value]
    }

    OnLauncherDoubleClickActionChange(ctl, info) {
        this.guiObj.Submit(false)
        this.app.Config.LauncherDoubleClickAction := this.doubleClickActions[ctl.Value]
    }

    OnBackupsViewModeChange(ctl, info) {
        this.guiObj.Submit(false)
        this.app.Config.BackupsViewMode := this.listViewModes[ctl.Value]
    }

    OnLoggingLevelChange(ctl, info) {
        this.guiObj.Submit(false)
        this.app.Config.LoggingLevel := ctl.Text
    }

    OnBackupsToKeepChange(ctl, info) {
        this.guiObj.Submit(false)
        this.app.Config.BackupsToKeep := ctl.Text
    }

    ProcessResult(result, submittedData := "") {
        if (this.needsRestart) {
            response := this.app.Service("GuiManager").Dialog("DialogBox", "Restart " . this.app.appName . "?", "One or more settings that have been changed require restarting " . this.app.appName . " to fully take effect.`n`nWould you like to restart " . this.app.appName . " now?")

            if (response == "Yes") {
                this.app.RestartApp()
            }
        }

        if (this.app.Service("GuiManager").WindowExists("MainWindow")) {
            this.app.Service("GuiManager").GetWindow("MainWindow").UpdateListView()
        }

        return result
    }
}
