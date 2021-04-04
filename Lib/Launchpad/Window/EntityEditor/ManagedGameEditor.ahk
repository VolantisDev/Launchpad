class ManagedGameEditor extends ManagedEntityEditorBase {
    __New(app, themeObj, windowKey, entityObj, mode := "config", owner := "", parent := "") {
        super.__New(app, themeObj, windowKey, entityObj, "Managed Game Editor", mode, owner, parent)
    }

    ExtraTabControls(tabs) {
        tabs.UseTab("Loading Window")
        this.AddCheckBoxBlock("HasLoadingWindow", "Game has loading window", true, "If the game has a loading or interstitial window, " . this.app.appName . " can optionally track that separately from the game window itself.", true)
        ctl := this.AddEntityCtl("Loading Window Process Type", "GameLoadingWindowProcessType", true, "SelectControl", this.processTypes, "OnGameLoadingWindowProcessTypeChange", "The process detection type to use for the loading window itself. See the Process tab for further details.")
        ctl.AddDependentField("GameLoadingWindowProcessId")
        this.AddTextBlock("GameLoadingWindowProcessId", "Loading Window Process ID", true, "The process ID for the loading window itself if applicable. See the Process ID field on the Process tab for full details.", false)
    }

    GetTabNames() {
        tabNames := super.GetTabNames()
        tabNames.Push("Loading Window")
        return tabNames
    }

    OnDefaultHasLoadingWindow(ctlObj, info) {
        return this.SetDefaultValue("HasLoadingWindow", !!(ctlObj.Value), true)
    }

    OnDefaultGameProcessId(ctlObj, info) {
        return this.SetDefaultValue("ProcessId", !!(ctlObj.Value), true)
    }

    OnDefaultGameLoadingWindowProcessId(ctlObj, info) {
        return this.SetDefaultValue("LoadingWindowProcessId", !!(ctlObj.Value), true)
    }

    OnHasLoadingWindowChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.HasLoadingWindow := !!(ctlObj.Value)
    }

    OnGameLoadingWindowProcessTypeChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.LoadingWindowProcessType := ctlObj.Text
        this.entityObj.UpdateDataSourceDefaults()
        this.guiObj["GameLoadingWindowProcessId"].Value := this.entityObj.LoadingWindowProcessId
    }

    OnGameLoadingWindowProcessIdChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.LoadingWindowProcessId := ctlObj.Text
    }

    OnGameInstallDirMenuClick(btn) {
        this.OnDirMenuClick("GameInstallDir", btn, "Select the game installation directory")
    }

    OnGameWorkingDirMenuClick(btn) {
        this.OnDirMenuClick("GameWorkingDir", btn, "Select the game working directory")
    }

    OnGameExeMenuClick(btn) {
        this.OnFileMenuClick("GameExe", btn, "Select the executable file", "Executables (*.exe)")
    }

    OnGameShortcutSrcMenuClick(btn) {
        this.OnFileMenuClick("GameShortcutSrc", btn, "Select a shortcut file or .exe that will launch the application", "Shortcuts (*.lnk; *.url; *.exe)")
    }

    OnGameLocateMethodChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.LocateMethod := ctlObj.Text
    }

    OnGameLocateRegViewChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entitObj.LocateRegView := ctlObj.Text
    }

    OnGameRunTypeChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.RunType := ctlObj.Text
    }

    OnGameRunMethodChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.RunMethod := ctlObj.Text
    }

    OnGameProcessTypeChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.ProcessType := ctlObj.Text
        this.entityObj.UpdateDataSourceDefaults()
        this.guiObj["GameProcessId"].Value := this.entityObj.ProcessId
    }

    OnGameProcessIdChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.ProcessId := ctlObj.Value
    }
}
