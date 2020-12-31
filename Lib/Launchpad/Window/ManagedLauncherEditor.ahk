class ManagedLauncherEditor extends ManagedEntityEditorBase {
    __New(app, entityObj, mode := "config", windowKey := "", owner := "", parent := "") {
        if (windowKey == "") {
            windowKey := "ManagedLauncherEditor"
        }

        super.__New(app, entityObj, "Managed Launcher Editor", mode, windowKey, owner, parent)
    }

    CustomTabControls() {
        ; @todo CloseBeforeRun
        ; @todo CloseAfterRun
        ; @todo ClosePreDelay
        ; @todo CLosePostDelay
        ; @todo CloseMethod
        ; @todo RecheckDelay
        ; @todo WaitTimeout
        ; @todo KillPreDelay
        ; @todo KillPostDelay
        ; @todo PoliteCloseWait
    }
}
