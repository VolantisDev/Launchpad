/**
    This GUI edits a GameLauncher object.

    Modes:
      - "config" - Launcher configuration is being edited
      - "build" - Launcher is being built and requires information
*/

class LauncherEditorBase extends EntityEditorBase {
    knownGames := ""
    knownThemes := ""
    launcherTypes := ""
    gameTypes := ""
    platforms := ""
    logLevels := ["None", "Error", "Warning", "Info", "Debug"]

    Controls() {
        super.Controls()
    }

    Create() {
        super.Create()
        this.knownGames := this.dataSource.ReadListing("game-keys")
        this.platforms := this.dataSource.ReadListing("platforms")
        this.launcherTypes := this.dataSource.ReadListing("launcher-types")
        this.gameTypes := this.dataSource.ReadListing("game-types")
        this.knownThemes := this.app.Themes.GetAvailableThemes(true)
    }

    OnDefaultThemeName(ctlObj, info) {
        return this.SetDefaultSelectValue("ThemeName", this.knownThemes, !!(ctlObj.Value))
    }

    OnDefaultDisplayName(ctlObj, info) {
        return this.SetDefaultValue("DisplayName", !!(ctlObj.Value))
    }

    OnDefaultRunBefore(ctlObj, info) {
        return this.SetDefaultValue("RunBefore", !!(ctlObj.Value))
    }

    OnDefaultRunAfter(ctlObj, info) {
        return this.SetDefaultValue("RunAfter", !!(ctlObj.Value))
    }

    OnDefaultCloseBefore(ctlObj, info) {
        return this.SetDefaultValue("CloseBefore", !!(ctlObj.Value))
    }

    OnDefaultCloseAfter(ctlObj, info) {
        return this.SetDefaultValue("CloseAfter", !!(ctlObj.Value))
    }

    OnDefaultGameType(ctlObj, info) {
        return this.SetDefaultValue("GameType", !!(ctlObj.Value))
    }

    OnDefaultIconSrc(ctlObj, info) {
        return this.SetDefaultLocationValue(ctlObj, "IconSrc", false)
    }

    OnDefaultLogPath(ctlObj, info) {
        return this.SetDefaultLocationValue(ctlObj, "LogPath", false)
    }

    OnDefaultLoggingLevel(ctlObj, info) {
        return this.SetDefaultValue("LoggingLevel", !!(ctlObj.Value))
    }

    OnDefaultDataSourceItemKey(ctlObj, info) {
        return this.SetDefaultValue("DataSourceItemKey", !!(ctlObj.Value))
    }

    OnDefaultShowProgress(ctlObj, info) {
        return this.SetDefaultValue("ShowProgress", !!(ctlObj.Value))
    }

    OnDefaultProgressTitle(ctlObj, info) {
        return this.SetDefaultValue("ProgressTitle", !!(ctlObj.Value))
    }

    OnDefaultProgressText(ctlObj, info) {
        return this.SetDefaultValue("ProgressText", !!(ctlObj.Value))
    }

    OnKeyChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.Key := ctlObj.Text
        ; @todo If new game type doesn't offer the selected launcher type, change to the default launcher type
    }

    OnLoggingLevelChange(ctl, info) {
        this.guiObj.Submit(false)
        this.entityObj.LoggingLevel := ctl.Text
    }

    OnDataSourceItemKeyChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.DataSourceItemKey := ctlObj.Text
    }

    OnPlatformChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.Platform := ctlObj.Text
        ; @todo Offer to set defaults
    }

    OnLauncherTypeChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.ManagedLauncher.EntityType := ctlObj.Text
        this.entityObj.ManagedLauncher.UpdateDataSourceDefaults()
        ; @todo If new launcher type changes the game type, change it here
    }

    OnGameTypeChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.ManagedLauncher.ManagedGame.EntityType := ctlObj.Text
        this.entityObj.ManagedLauncher.ManagedGame.UpdateDataSourceDefaults()
    }

    OnLauncherConfiguration(ctlObj, info) {
        entity := this.entityObj.ManagedLauncher
        diff := entity.Edit(this.mode, this.guiObj)

        if (diff != "" && diff.HasChanges()) {
            if (diff.ValueIsModified("LauncherType")) {
                this.guiObj["LauncherType"].Value := this.GetItemIndex(this.launcherTypes, entity.GetConfigValue("Type"))
            }
        }
    }

    OnGameConfiguration(ctlObj, info) {
        entity := this.entityObj.ManagedLauncher.ManagedGame
        diff := entity.Edit(this.mode, this.guiObj)

        if (diff != "" && diff.HasChanges()) {
            if (diff.ValueIsModified("GameType")) {
                this.guiObj["GameType"].Value := this.GetItemIndex(this.gameTypes, entity.GetConfigValue("Type"))
            }
        }
    }

    OnDisplayNameChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.DisplayName := ctlObj.Value
    }

    OnRunBeforeChange(ctlObj, info) {
        this.SetProcessList("RunBefore", ctlObj)
    }

    OnRunAfterChange(ctlObj, info) {
        this.SetProcessList("RunAfter", ctlObj)
    }

    OnCloseBeforeChange(ctlObj, info) {
        this.SetProcessList("CloseBefore", ctlObj)
    }

    OnCloseAfterChange(ctlObj, info) {
        this.SetProcessList("CloseAfter", ctlObj)
    }

    SetProcessList(property, ctlObj) {
        this.guiObj.Submit(false)
        value := StrReplace(ctlObj.Value, "`r`n", ";")
        value := StrReplace(value, "`n", ";")
        this.entityObj.%property% := value
    }

    OnChangeIconSrc(btn, info) {
        existingVal := this.entityObj.GetConfigValue("IconSrc", false)
        file := FileSelect(1,, this.entityObj.Key . ": Select icon or .exe to extract icon from.", "Icons (*.ico; *.exe)")

        if (file) {
            this.entityObj.SetConfigValue("IconSrc", file, false)
            this.guiObj["IconSrc"].Text := file
        }
    }

    OnOpenIconSrc(btn, info) {
        if (this.entityObj.IconSrc && FileExist(this.entityObj.IconSrc)) {
            Run this.entityObj.IconSrc
        }
    }

    OnClearIconSrc(btn, info) {
        if (this.entityObj.UnmergedConfig.Has("IconSrc")) {
            this.entityObj.UnmergedConfig.Delete("IconSrc")
            this.guiObj["IconSrc"].Text := this.entityObj.IconSrc
        }
    }

    OnChangeLogPath(btn, info) {
        existingVal := this.entityObj.GetConfigValue("LogPath", false)
        file := FileSelect(8,, this.entityObj.Key . ": Select or create log file.", "Files (*.*)")

        if (file) {
            this.entityObj.SetConfigValue("LogPath", false)
            this.guiObj["LogPath"].Text := file
        }
    }

    OnOpenLogPath(btn, info) {
        if (this.entityObj.LogPath && FileExist(this.entityObj.LogPath)) {
            Run this.entityObj.LogPath
        }
    }

    OnClearLogPath(btn, info) {
        if (this.entityObj.UnmergedConfig.Has("LogPath")) {
            this.entityObj.UnmergedConfig.Delete("LogPath")
            this.guiObj["LogPath"].Text := this.entityObj.LogPath
        }
    }

    OnThemeNameChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.ThemeName := ctlObj.Text
    }

    OnShowProgressChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.ShowProgress := !!(ctlObj.Value)
    }

    OnProgressTitleChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.ProgressTitle := ctlObj.Text
    }

    OnProgressTextChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.ProgressText := ctlObj.Text
    }
}
