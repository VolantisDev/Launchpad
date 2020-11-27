class AhkLauncherBuilder extends BuilderBase {
    BuildAction(launcherGameObj, launcherDir, assetsDir) {
        result := false

        gameAhkObj := GameAhkFile.new(this.app, launcherGameObj, assetsDir, launcherGameObj.Key)
        ahkResult := gameAhkObj.Build()

        if (ahkResult) {
            gameExeObj := GameExeFile.new(this.app, launcherGameObj, launcherDir, launcherGameObj.Key)
            result := gameExeObj.Build()
        }

        return result
    }

    Clean(launcherGameObj) {
        wasCleaned := false

        filePath := this.app.Config.AssetsDir . "\" . launcherGameObj.Key . "\" . launcherGameObj.Key . ".ahk"

        if (FileExist(filePath)) {
            FileDelete(filePath)
            wasCleaned := true
        }

        return wasCleaned
    }
}
