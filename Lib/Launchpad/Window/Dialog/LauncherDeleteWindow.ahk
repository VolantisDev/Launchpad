class LauncherDeleteWindow extends EntityDeleteWindow {
    Controls() {
        super.Controls()
        this.Add("BasicControl", "vDeleteLauncher", "", false, "CheckBox", "Delete generated launcher")
        this.Add("BasicControl", "vDeleteAssets", "", false, "CheckBox", "Delete launcher assets")
    }

    ProcessResult(result, submittedData := "") {
        if (result == "Delete") {
            if (submittedData.DeleteLauncher and this.entityObj.IsBuilt) {
                file := this.entityObj.GetLauncherFile(this.entityObj.Key, false)

                if (file and FileExist(file)) {
                    FileDelete(file)
                }
            }

            if (submittedData.DeleteAssets) {
                assetsDir := this.entityObj.AssetsDir

                if (assetsDir and DirExist(assetsDir)) {
                    DirDelete(assetsDir, true)
                }
            }

            this.app.State.DeleteLauncherInfo(this.entityObj.Key)
        }

        return super.ProcessResult(result, submittedData)
    }
}
