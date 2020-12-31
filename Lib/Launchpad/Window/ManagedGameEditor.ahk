class ManagedGameEditor extends ManagedEntityEditorBase {
    __New(app, entityObj, mode := "config", windowKey := "", owner := "", parent := "") {
        if (windowKey == "") {
            windowKey := "ManagedGameEditor"
        }

        super.__New(app, entityObj, "Managed Game Editor", mode, windowKey, owner, parent)
    }

    CustomTabControls() {
        this.AddCheckBoxBlock("HasLoadingWindow", "Game has loading window", true, "If the game has a loading or interstitial window, Launchpad can optionally track that separately from the game window itself.", true)
        this.AddSelect("Loading Window Process Type", "LoadingWindowProcessType", this.entityObj.LoadingWindowProcessType, this.processTypes, true, "", "", "The process detection type to use for the loading window itself. See the Process tab for further details.", true)
        this.AddTextBlock("LoadingWindowProcessId", "Loading Window Process ID", true, "The process ID for the loading window itself if applicable. See the Process ID field on the Process tab for full details.", true)
    }

    OnDefaultHasLoadingWindow(ctlObj, info) {
        return this.SetDefaultValue("HasLoadingWindow", !!(ctlObj.Value), true)
    }

    OnDefaultLoadingWindowProcessType(ctlObj, info) {
        val := this.SetDefaultSelectValue("LoadingWindowProcessType", this.processTypes, !!(ctlObj.Value), true)
        this.entityObj.UpdateDataSourceDefaults()
        this.guiObj["LoadingWindowProcessId"].Value := this.entityObj.LoadingWindowProcessId
        return val
    }

    OnDefaultLoadingWindowProcessId(ctlObj, info) {
        return this.SetDefaultValue("LoadingWindowProcessId", !!(ctlObj.Value), true)
    }

    OnHasLoadingWindowChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.HasLoadingWindow := !!(ctlObj.Value)
    }

    OnLoadingWindowProcessTypeChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.LoadingWindowProcessType := ctlObj.Text
        this.entityObj.UpdateDataSourceDefaults()
        this.guiObj["LoadingWindowProcessId"].Value := this.entityObj.LoadingWindowProcessId
    }

    OnLoadingWindowProcessIdChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.LoadingWindowProcessId := ctlObj.Text
    }
}
