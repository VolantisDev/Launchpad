class EditableLauncherGame extends LauncherGameBase {
    originalObj := ""

    ; This retains a copy of the launcher game before any modifications were made during editing so that it can be compared later.
    ; This is populated prior to editing a launcher game, and deleted after the editing operation is completed.
    ; For example, if the key is changed, this will ensure the original item will be removed when the revised item is saved with a new key.
    Original[] {
        get => (this.originalObj != "") ? this.originalObj : this.StoreOriginal()
        set => this.originalObj := value
    }

    Edit(launcherFileObj := "", mode := "config", owner := "MainWindow") {
        this.StoreOriginal()

        result := this.app.Windows.LauncherEditor(this, mode, owner)

        if (mode == "config" and launcherFileObj != "") {
            ; @todo save launcher data back to the provided launcher file object
        }

        return this.Validate()
    }

    StoreOriginal() {
        this.originalObj := this.Clone()
        this.originalObj.configVal := this.configVal.Clone()
        return this.originalObj
    }
}
