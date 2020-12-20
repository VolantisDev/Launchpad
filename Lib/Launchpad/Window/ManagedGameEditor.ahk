class ManagedGameEditor extends ManagedEntityEditorBase {
    __New(app, entityObj, mode := "config", windowKey := "", owner := "", parent := "") {
        if (windowKey == "") {
            windowKey := "ManagedGameEditor"
        }

        super.__New(app, entityObj, "Managed Game Editor", mode, windowKey, owner, parent)
    }
}
