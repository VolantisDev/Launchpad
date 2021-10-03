class AhkLauncherBuilder extends BuilderBase {
    BuildAction(entityObj, launcherDir, assetsDir) {
        result := false

        gameAhkObj := GameAhkFile(entityObj)
        ahkResult := gameAhkObj.Build()

        if (ahkResult) {
            gameExeObj := GameExeFile(entityObj)
            result := gameExeObj.Build()

            if (result) {
                if (this.app.Config.create_desktop_shortcuts) {
                    this.CreateShortcut(entityObj)
                }

                this.app.State.SetLauncherBuildInfo(entityObj.Key)
            }
        }

        return result
    }

    CreateShortcut(entityObj) {
        if (entityObj.LauncherExists(false)) {
            launcherExe := entityObj.GetLauncherFile(entityObj.Key, false)
            shortcutPath := A_Desktop . "\" . entityObj.Key . ".lnk"

            FileCreateShortcut(launcherExe, shortcutPath)
        }
    }

    Clean(entityObj) {
        wasCleaned := false

        filePath := this.app.Config.assets_dir . "\" . entityObj.Key . "\" . entityObj.Key . ".ahk"

        if (FileExist(filePath)) {
            FileDelete(filePath)
            wasCleaned := true
        }

        return wasCleaned
    }
}
