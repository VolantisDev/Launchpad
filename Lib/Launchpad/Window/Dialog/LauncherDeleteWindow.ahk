class LauncherDeleteWindow extends EntityDeleteWindow {
    Controls() {
        super.Controls()
        this.Add("BasicControl", "vDeleteLauncher", "", false, "CheckBox", "Delete generated launcher")
        this.Add("BasicControl", "vDeleteAssets", "", false, "CheckBox", "Delete launcher assets")
    }

    ProcessResult(result, submittedData := "") {
        if (result == "Delete") {
            if (submittedData.DeleteLauncher and this.entityObj.IsBuilt) {
                filePath := this.entityObj.GetLauncherFile(this.entityObj.Key, false)

                if (filePath and FileExist(filePath)) {
                    FileDelete(filePath)
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
