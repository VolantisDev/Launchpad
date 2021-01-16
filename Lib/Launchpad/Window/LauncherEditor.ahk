/**
    This GUI edits a GameLauncher object.

    Modes:
      - "config" - Launcher configuration is being edited
      - "build" - Launcher is being built and requires information
*/

class LauncherEditor extends EntityEditorBase {
    knownGames := ""
    knownThemes := ""
    launcherTypes := ""
    gameTypes := ""

    __New(app, entityObj, mode := "config", windowKey := "", owner := "", parent := "") {
        if (windowKey == "") {
            windowKey := "LauncherEditor"
        }

        if (owner == "") {
            owner := "MainWindow"
        }

        super.__New(app, entityObj, "Launcher Editor", mode, windowKey, owner, parent)
    }

    Controls() {
        super.Controls()
        tabs := this.guiObj.Add("Tab3", " x" . this.margin . " w" . this.windowSettings["contentWidth"] . " +0x100", ["General", "Sources", "UI", "Advanced"])

        tabs.UseTab("General", true)
        this.AddComboBox("Key", "Key", this.entityObj.Key, this.knownGames, "Select an existing game from the API, or enter a custom game key to create your own. Use caution when changing this value, as it will change which data is requested from the API.")
        this.AddTextBlock("DisplayName", "Display Name", true, "You can change the display name of the game if it differs from the key. The launcher filename will still be created using the key.")
        this.AddEntityTypeSelect("Launcher", "LauncherType", this.entityObj.ManagedLauncher.EntityType, this.launcherTypes, "LauncherConfiguration", "This tells Launchpad how to interact with any launcher your game might require. If your game's launcher isn't listed, or your game doesn't have a launcher, start with `"Default`".")
        this.AddEntityTypeSelect("Game", "GameType", this.entityObj.ManagedLauncher.ManagedGame.EntityType, this.gameTypes, "GameConfiguration", "This tells Launchpad how to launch your game. Most games can use 'default', but launchers can support different game types.")

        tabs.UseTab("Sources", true)
        this.AddLocationBlock("Icon Source", "IconSrc", "Clear")
        ; @todo Add data source keys checkboxes
        this.AddTextBlock("DataSourceItemKey", "DataSource Item Key", true, "The key to use when looking this item up in its datasource(s). By default, this is the same as the main key.")

        tabs.UseTab("UI", true)
        this.AddSelect("Launcher Theme", "ThemeName", this.entityObj.ThemeName, this.knownThemes, true, "", "", "The theme to use if/when the launcher shows GUI windows")
        this.AddCheckBoxBlock("ShowProgress", "Show Progress Window", true, "Whether or not to show a window indicating the current status of the launcher")
        this.AddTextBlock("ProgressTitle", "Progress Window Title", true, "The title that the progress window will use if shown")
        this.AddTextBlock("ProgressText", "Progress Window Text", true, "The text displayed at the top of the progress window if shown")

        tabs.UseTab("Advanced", true)
        this.AddTextBlock("RunBefore", "Run Before Game", true, "Run one or more processes before launching the game. Each line should contain a command to run or a full path to a .exe or shortcut file to launch.`n`nEach process will be run as a scheduled task so that it is not owned by the launcher.", false, 3, ";")
        this.AddTextBlock("CloseBefore", "Close Before Game", true, "Close one or more processes before launching the game. Each line should contain the name of the process to close (usually just the .exe filename).", false, 3, ";")
        this.AddTextBlock("RunAfter", "Run After Game", true, "Run one or more processes after closing the game. Each line should contain a command to run or a full path to a .exe or shortcut file to launch.`n`nEach process will be run as a scheduled task so that it is not owned by the launcher.", false, 3, ";")
        this.AddTextBlock("CloseAfter", "Close After Game", true, "Close one or more processes after closing the game. Each line should contain the name of the process to close (usually just the .exe filename).", false, 3, ";")

        tabs.UseTab()
    }

    Create() {
        super.Create()
        this.knownGames := this.dataSource.ReadListing("Games")
        this.launcherTypes := this.dataSource.ReadListing("Types/Launchers")
        this.gameTypes := this.dataSource.ReadListing("Types/Games")
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

    OnDataSourceItemKeyChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.DataSourceItemKey := ctlObj.Text
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
        if (this.entityObj.IconSrc) {
            Run this.entityObj.IconSrc
        }
    }

    OnClearIconSrc(btn, info) {
        if (this.entityObj.UnmergedConfig.Has("IconSrc")) {
            this.entityObj.UnmergedConfig.Delete("IconSrc")
            this.guiObj["IconSrc"].Text := this.entityObj.IconSrc
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
