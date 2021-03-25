class LauncherDeleteWindow extends EntityDeleteWindow {
    deleteLauncher := false
    deleteAssets := false

    Controls() {
        super.Controls()

        ctl := this.AddCheckBox("Delete generated launcher", "DeleteLauncher", this.deleteLauncher, false)
        ctl := this.AddCheckBox("Delete launcher assets", "DeleteAssets", this.deleteAssets, false)
    }

    OnDeleteLauncher(ctl, info) {
        this.guiObj.Submit(false)
        this.deleteLauncher := !!ctl.Value
    }

    OnDeleteAssets(ctl, info) {
        this.guiObj.Submit(false)
        this.deleteAssets := !!ctl.Value
    }

    ProcessResult(result) {
        if (result == "Delete") {
            if (this.deleteLauncher and this.entityObj.IsBuilt) {
                file := this.entityObj.GetLauncherFile(this.entityObj.Key, false)

                if (file and FileExist(file)) {
                    FileDelete(file)
                }
            }

            if (this.deleteAssets) {
                assetsDir := this.entityObj.AssetsDir

                if (assetsDir and DirExist(assetsDir)) {
                    DirDelete(assetsDir, true)
                }
            }
        }

        return super.ProcessResult(result)
    }
}
