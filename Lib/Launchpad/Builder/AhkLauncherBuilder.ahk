class AhkLauncherBuilder extends BuilderBase {
    BuildAction(entityObj, launcherDir, assetsDir) {
        result := false

        gameAhkObj := GameAhkFile(entityObj)
        ahkResult := gameAhkObj.Build()

        if (ahkResult) {
            gameExeObj := GameExeFile(entityObj)
            result := gameExeObj.Build()

            if (result) {
                if (this.app.Config["create_desktop_shortcuts"]) {
                    this.CreateShortcut(entityObj)
                }

                this.app.State.SetLauncherBuildInfo(entityObj.Id)
            }
        }

        return result
    }

    CreateShortcut(entityObj) {
        if (entityObj.LauncherExists(false)) {
            launcherExe := entityObj.GetLauncherFile(entityObj.Id, false)
            shortcutPath := A_Desktop . "\" . entityObj.Id . ".lnk"

            FileCreateShortcut(launcherExe, shortcutPath)
        }
    }

    Clean(entityObj) {
        wasCleaned := false

        filePath := this.app.Config["assets_dir"] . "\" . entityObj.Id . "\" . entityObj.Id . ".ahk"

        if (FileExist(filePath)) {
            FileDelete(filePath)
            wasCleaned := true
        }

        return wasCleaned
    }
}
