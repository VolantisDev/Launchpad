class ManagedGameEditor extends ManagedEntityEditorBase {
    __New(app, entityObj, mode := "config", windowKey := "", owner := "", parent := "") {
        if (windowKey == "") {
            windowKey := "ManagedGameEditor"
        }

        super.__New(app, entityObj, "Managed Game Editor", mode, windowKey, owner, parent)
    }

    CustomTabControls() {
        ; @todo Launcher-Specific ID
        ; @todo Has Loading Window
        ; @todo Loading Window Process Type
        ; @todo Loading Window Process ID
    }
}
