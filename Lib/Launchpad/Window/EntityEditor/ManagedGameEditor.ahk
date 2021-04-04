class ManagedGameEditor extends ManagedEntityEditorBase {
    __New(app, themeObj, windowKey, entityObj, mode := "config", owner := "", parent := "") {
        super.__New(app, themeObj, windowKey, entityObj, "Managed Game Editor", mode, owner, parent)
    }

    ExtraTabControls(tabs) {
        tabs.UseTab("Loading Window")
        ctl := this.AddEntityCtl("", "GameHasLoadingWindow", true, "BasicControl", "CheckBox", "Game has loading window")
        ctl.ctl.ToolTip := "If the game has a loading or interstitial window, " . this.app.appName . " can optionally track that separately from the game window itself."
        ctl := this.AddEntityCtl("Loading Window Process Type", "GameLoadingWindowProcessType", true, "SelectControl", this.processTypes, "", "The process detection type to use for the loading window itself. See the Process tab for further details.")
        ctl.AddDependentField("GameLoadingWindowProcessId")
        this.AddTextBlock("GameLoadingWindowProcessId", "Loading Window Process ID", true, "The process ID for the loading window itself if applicable. See the Process ID field on the Process tab for full details.", false)
    }

    GetTabNames() {
        tabNames := super.GetTabNames()
        tabNames.Push("Loading Window")
        return tabNames
    }

    OnDefaultGameProcessId(ctlObj, info) {
        return this.SetDefaultValue("ProcessId", !!(ctlObj.Value), true)
    }

    OnDefaultGameLoadingWindowProcessId(ctlObj, info) {
        return this.SetDefaultValue("LoadingWindowProcessId", !!(ctlObj.Value), true)
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

    OnGameProcessIdChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.ProcessId := ctlObj.Value
    }
}
