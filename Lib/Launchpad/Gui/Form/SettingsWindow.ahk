class SettingsWindow extends FormGuiBase {
    availableThemes := Map()
    listViewModes := ["Report", "Tile", "List"]
    doubleClickActions := ["Edit", "Run"]
    needsRestart := false

    __New(container, themeObj, config) {
        this.availableThemes := container.Get("manager.theme").GetAvailableThemes()
        super.__New(container, themeObj, config)
    }

    GetDefaultConfig(container, config) {
        defaults := super.GetDefaultConfig(container, config)
        defaults["ownerOrParent"] := "MainWindow"
        defaults["child"] := false
        defaults["title"] := "Settings"
        defaults["buttons"] := "*&Done"
        return defaults
    }

    Controls() {
        super.Controls()
        buttonSize := this.themeObj.GetButtonSize("s", true)
        buttonW := (buttonSize.Has("w") && buttonSize["w"] != "auto") ? buttonSize["w"] : 80
        ctl := this.Add("TabsControl", "vSettingsTabs", "", ["Launchers", "Platforms", "Backups", "Appearance", "Cache", "Advanced"])
        tabs := ctl.ctl

        tabs.UseTab("Launchers", true)

        this.AddHeading("Double-Click Action")
        chosen := this.GetItemIndex(this.doubleClickActions, this.app.Config["launcher_double_click_action"])
        ctl := this.guiObj.AddDDL("vlauncher_double_click_action xs y+m Choose" . chosen . " w250 c" . this.themeObj.GetColor("editText"), this.doubleClickActions)
        ctl.OnEvent("Change", "OnLauncherDoubleClickActionChange")
        ctl.ToolTip := "Select what you would like to happen when double-clicking a launcher in the main list."

        this.AddConfigLocationBlock("Launcher File", "launcher_file", "Reload")
        this.AddConfigLocationBlock("Launcher Directory", "destination_dir")
        this.AddConfigLocationBlock("Assets Directory", "assets_dir")

        this.AddHeading("Launcher Settings")
        this.AddConfigCheckBox("Create desktop shortcuts for launchers", "create_desktop_shortcuts")
        this.AddConfigCheckBox("Rebuild existing launchers when building all launchers", "rebuild_existing_launchers")
        this.AddConfigCheckBox("Use advanced launcher editor by default", "use_advanced_launcher_editor")
        this.AddConfigCheckBox("Clean launchers automatically when building", "clean_launchers_on_build")
        this.AddConfigCheckBox("Clean launchers automatically when exiting Launchpad", "clean_launchers_on_exit")

        tabs.UseTab("Platforms", true)

        this.Add("ButtonControl", "", "Manage Platforms", "OnManagePlatforms")

        this.AddHeading("Platforms View Mode")
        chosen := this.GetItemIndex(this.listViewModes, this.app.Config["platforms_view_mode"])
        ctl := this.guiObj.AddDDL("vplatforms_view_mode xs y+m Choose" . chosen . " w250 c" . this.themeObj.GetColor("editText"), this.listViewModes)
        ctl.OnEvent("Change", "OnPlatformsViewModeChange")
        ctl.ToolTip := "Select how you would like to view your platforms in the Platform Manager."

        this.AddConfigLocationBlock("Platforms File", "platforms_file", "Reload")

        tabs.UseTab("Backups")

        this.Add("ButtonControl", "", "Manage Backups", "OnManageBackups")

        this.AddHeading("Backups View Mode")
        chosen := this.GetItemIndex(this.listViewModes, this.app.Config["backups_view_mode"])
        ctl := this.guiObj.AddDDL("vbackups_view_mode xs y+m Choose" . chosen . " w250 c" . this.themeObj.GetColor("editText"), this.listViewModes)
        ctl.OnEvent("Change", "OnBackupsViewModeChange")
        ctl.ToolTip := "Select how you would like to view your backups in the Backup Manager."

        this.AddConfigLocationBlock("Backup Dir", "backup_dir", "&Manage")
        this.AddConfigLocationBlock("Backups File", "backups_file")

        this.AddHeading("Backups to Keep")
        ctl := this.AddEdit("backups_to_keep", this.app.Config["backups_to_keep"], "y+" . this.margin, 100)
        ctl.OnEvent("Change", "OnBackupsToKeepChange")
        this.guiObj.AddText("w" . this.windowSettings["contentWidth"] " y+" . this.margin, "Note: This can be overridden for individual backups in the Backup Manager.")

        this.AddHeading("Backup Options")
        this.AddConfigCheckbox("Automatically back up config files", "auto_backup_config_files")

        tabs.UseTab("Appearance", true)

        this.AddHeading("Launchpad Theme")
        chosen := this.GetItemIndex(this.availableThemes, this.app.Config["theme_name"])
        ctl := this.guiObj.AddDDL("vtheme_name xs y+m Choose" . chosen . " w250 c" . this.themeObj.GetColor("editText"), this.availableThemes)
        ctl.OnEvent("Change", "OnThemeNameChange")
        ctl.ToolTip := "Select a theme for Launchpad to use."

        this.Add("ButtonControl", "", "Reload Launchpad", "OnReload")

        this.AddHeading("Default Launcher Theme")
        chosen := this.GetItemIndex(this.availableThemes, this.app.Config["default_launcher_theme"])
        ctl := this.guiObj.AddDDL("vdefault_launcher_theme xs y+m Choose" . chosen . " w250 c" . this.themeObj.GetColor("editText"), this.availableThemes)
        ctl.OnEvent("Change", "OnDefaultLauncherThemeChange")
        ctl.ToolTip := "Select the theme your launchers will use unless overridden."

        this.AddConfigCheckBox("Override API launcher themes with the default theme", "override_launcher_theme")

        tabs.UseTab("Cache", true)

        this.AddConfigLocationBlock("Cache Dir", "cache_dir", "&Flush")

        this.AddHeading("Cache Settings")
        this.AddConfigCheckBox("Flush cache on exit (Recommended only for debugging)", "flush_cache_on_exit")

        tabs.UseTab("Advanced", true)

        this.AddHeading("Updates")
        this.AddConfigCheckBox("Check for updates on start", "check_updates_on_start")

        this.AddHeading("Logging Level")
        chosen := this.GetItemIndex(this.container.Get("logger").GetLogLevels(), this.app.Config["logging_level"])
        ctl := this.guiObj.AddDDL("vlogging_level xs y+m Choose" . chosen . " w200 c" . this.themeObj.GetColor("editText"), this.container.Get("logger").GetLogLevels())
        ctl.OnEvent("Change", "OnLoggingLevelChange")

        this.AddConfigLocationBlock("API Endpoint", "api_endpoint")

        this.AddHeading("API Settings")
        ctl := this.AddConfigCheckBox("Enable API login for enhanced functionality", "api_authentication")
        ctl.ctl.NeedsRestart := true
        ctl := this.AddConfigCheckBox("Automatically initiate API login when needed", "api_auto_login")
        ctl.ctl.NeedsRestart := true

        tabs.UseTab()

        closeW := 100
        closeX := this.margin + this.windowSettings["contentWidth"] - closeW
    }

    OnManageBackups(btn, info) {
        this.app.Service("manager.gui").OpenWindow("ManageBackupsWindow")
    }

    OnManagePlatforms(btn, info) {
        this.app.Service("manager.gui").OpenWindow("PlatformsWindow")
    }

    AddConfigLocationBlock(heading, settingName, extraButton := "", helpText := "") {
        location := this.app.Config[settingName] ? this.app.Config[settingName] : "Not selected"
        return this.Add("LocationBlock", "", heading, location, settingName, extraButton, true, helpText)
    }

    AddConfigCheckbox(checkboxText, settingName) {
        isChecked := this.app.Config[settingName]
        opts := ["v" . settingName, "w" . this.windowSettings["contentWidth"], "Checked" . isChecked]
        ctl := this.Add("BasicControl", opts, "", "", "CheckBox", checkboxText)
        ctl.RegisterHandler("Click", "OnSettingsCheckbox")
        return ctl
    }

    OnSettingsCheckbox(chk, info) {
        this.guiObj.Submit(false)
        ctlName := chk.Name
        this.app.Config[ctlName] := chk.Value

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
            this.SetText("LauncherFile", this.app.Config["launcher_file"], "Bold")
        } else if (btn == "OpenLauncherFile") {
            this.app.Config.OpenLauncherFile()
        } else if (btn == "ReloadLauncherFile") {
            this.app.Service("entity_manager.launcher").LoadComponents(true)
        }
    }

    OnBackupsFileMenuClick(btn) {
        if (btn == "ChangeBackupsFile") {
            this.app.Config.ChangeBackupsFile()
            this.SetText("BackupsFile", this.app.Config["backups_file"], "Bold")
        } else if (btn == "OpenBackupsFile") {
            this.app.Config.OpenBackupsFile()
        } else if (btn == "ReloadBackupsFile") {
            this.app.Service("entity_manager.backup").LoadComponents(true)
        }
    }

    OnPlatformsFileMenuClick(btn) {
        if (btn == "ChangePlatformsFile") {
            this.app.Config.ChangePlatformsFile()
            this.SetText("PlatformsFile", this.app.Config["platforms_file"], "Bold")
        } else if (btn == "OpenPlatformsFile") {
            this.app.Config.OpenPlatformsFile()
        } else if (btn == "ReloadPlatformsFile") {
            this.app.Service("entity_manager.platform").LoadComponents(true)
        }
    }

    OnDestinationDirMenuClick(btn) {
        if (btn == "ChangeDestinationDir") {
            this.app.Config.ChangeDestinationDir()
            this.SetText("DestinationDir", this.app.Config["destination_dir"], "Bold")
            this.needsRestart := true
        } else if (btn == "OpenDestinationDir") {
            this.app.Config.OpenDestinationDir()
        }
    }

    OnApiTokenChange(ctl, info) {
        this.guiObj.Submit(false)
        this.needsRestart := true
        this.app.Config["api_token"] := ctl.Text
    }

    OnAssetsDirMenuClick(btn) {
        if (btn == "ChangeAssetsDir") {
            this.app.Config.ChangeAssetsDir()
            this.SetText("AssetsDir", this.app.Config["assets_dir"], "Bold")
            this.needsRestart := true
        } else if (btn == "OpenAssetsDir") {
            this.app.Config.OpenAssetsDir()
        }
    }

    OnApiEndpointMenuClick(btn) {
        if (btn == "ChangeApiEndpoint") {
            this.app.Service("manager.data_source").GetDefaultDataSource().ChangeApiEndpoint("", "")
            this.SetText("ApiEndpoint", this.app.Config["api_endpoint"], "Bold")
            this.needsRestart := true
        } else if (btn == "OpenApiEndpoint") {
            this.app.Service("manager.data_source").GetDefaultDataSource().Open()
        }
    }

    OnCacheDirMenuClick(btn) {
        if (btn == "ChangeCacheDir") {
            this.app.Service("manager.cache").ChangeCacheDir()
            this.SetText("CacheDir", this.app.Config["cache_dir"], "Bold")
        } else if (btn == "OpenCacheDir") {
            this.app.Service("manager.cache").OpenCacheDir()
        } else if (btn == "FlushCacheDir") {
            this.app.Service("manager.cache").FlushCaches(true, true)
        }
    }

    OnBackupDirMenuClick(btn) {
        if (btn == "ChangeBackupDir") {
            this.app.Service("entity_manager.backup").ChangeBackupDir()
            this.SetText("BackupDir", this.app.Config["backup_dir"], "Bold")
            this.needsRestart := true
        } else if (btn == "OpenBackupDir") {
            this.app.Service("entity_manager.backup").OpenBackupDir()
        }
    }

    OnThemeNameChange(ctl, info) {
        this.guiObj.Submit(false)
        this.app.Config["theme_name"] := this.availableThemes[ctl.Value]
        this.needsRestart := true
    }

    OnDefaultLauncherThemeChange(ctl, info) {
        this.guiObj.Submit(false)
        this.app.Config["default_launcher_theme"] := this.availableThemes[ctl.Value]
    }

    OnPlatformsViewModeChange(ctl, info) {
        this.guiObj.Submit(false)
        this.app.Config["platforms_view_mode"] := this.listViewModes[ctl.Value]
    }

    OnLauncherDoubleClickActionChange(ctl, info) {
        this.guiObj.Submit(false)
        this.app.Config["launcher_double_click_action"] := this.doubleClickActions[ctl.Value]
    }

    OnBackupsViewModeChange(ctl, info) {
        this.guiObj.Submit(false)
        this.app.Config["backups_view_mode"] := this.listViewModes[ctl.Value]
    }

    OnLoggingLevelChange(ctl, info) {
        this.guiObj.Submit(false)
        this.app.Config["logging_level"] := ctl.Text
    }

    OnBackupsToKeepChange(ctl, info) {
        this.guiObj.Submit(false)
        this.app.Config["backups_to_keep"] := ctl.Text
    }

    ProcessResult(result, submittedData := "") {
        ; TODO: Add temporary storage and a Cancel button to the Settings window
        this.app.Config.SaveConfig()

        if (this.needsRestart) {
            response := this.app.Service("manager.gui").Dialog(Map(
                "title", "Restart " . this.app.appName . "?",
                "text", "One or more settings that have been changed require restarting " . this.app.appName . " to fully take effect.`n`nWould you like to restart " . this.app.appName . " now?"
            ))

            if (response == "Yes") {
                this.app.RestartApp()
            }
        }

        if (this.app.Service("manager.gui").Has("MainWindow")) {
            this.app.Service("manager.gui")["MainWindow"].UpdateListView()
        }

        return result
    }
}
