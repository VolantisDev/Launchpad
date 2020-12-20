class ManagedLauncherEditor extends ManagedEntityEditorBase {
    __New(app, entityObj, mode := "config", windowKey := "", owner := "", parent := "") {
        if (windowKey == "") {
            windowKey := "ManagedLauncherEditor"
        }

        super.__New(app, entityObj, "Managed Launcher Editor", mode, windowKey, owner, parent)
    }
}
