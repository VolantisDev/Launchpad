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
        this.knownThemes := this.app.Service("ThemeManager").GetAvailableThemes()
    }

    OnKeyChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.Key := ctlObj.Text
        ; TODO: If new game type doesn't offer the selected launcher type, change to the default launcher type
    }

    OnManageLauncherType(ctlObj, info) {
        this.EditManagedEntityType(this.entityObj.ManagedLauncher, "LauncherType")
    }

    OnManageGameType(ctlObj, info) {
        this.EditManagedEntityType(this.entityObj.ManagedLauncher.ManagedGame, "GameType")
    }

    EditManagedEntityType(entity, field) {
        diff := entity.Edit("child", this.guiObj)

        if (diff != "" && diff.HasChanges()) {
            if (diff.ValueIsModified(field)) {
                this.guiObj[field].Value := this.GetItemIndex(this.gameTypes, entity.Config[field])
            }
        }
    }

    OnIconSrcMenuClick(btn) {
        if (btn == "ChangeIconSrc") {
            existingVal := this.entityObj.GetConfigValue("IconSrc", false)
            filePath := FileSelect(1,, this.entityObj.Key . ": Select icon or .exe to extract icon from.", "Icons (*.ico; *.exe)")

            if (filePath) {
                this.entityObj.SetConfigValue("IconSrc", filePath, false)
                this.guiObj["IconSrc"].Text := filePath
            }
        } else if (btn == "ClearIconSrc") {
            if (this.entityObj.UnmergedConfig.Has("IconSrc")) {
                this.entityObj.UnmergedConfig.Delete("IconSrc")
                this.guiObj["IconSrc"].Text := this.entityObj.IconSrc
            }
        }
    }

    OnLogPathMenuClick(btn) {
        if (btn == "ChangeLogPath") {
            existingVal := this.entityObj.GetConfigValue("LogPath", false)
            filePath := FileSelect(8,, this.entityObj.Key . ": Select or create log file.", "Files (*.*)")

            if (filePath) {
                this.entityObj.SetConfigValue("LogPath", false)
                this.guiObj["LogPath"].Text := filePath
            }
        } else if (btn == "OpenLogPath") {
            if (this.entityObj.LogPath && FileExist(this.entityObj.LogPath)) {
                Run this.entityObj.LogPath
            }
        } else if (btn == "ClearLogPath") {
            if (this.entityObj.UnmergedConfig.Has("LogPath")) {
                this.entityObj.UnmergedConfig.Delete("LogPath")
                this.guiObj["LogPath"].Text := this.entityObj.LogPath
            }
        }
    }
}
