class AhkLauncherBuilder extends BuilderBase {
    BuildAction(entityObj, launcherDir, assetsDir) {
        result := false

        gameAhkObj := GameAhkFile.new(entityObj)
        ahkResult := gameAhkObj.Build()

        if (ahkResult) {
            gameExeObj := GameExeFile.new(entityObj)
            result := gameExeObj.Build()
        }

        return result
    }

    Clean(entityObj) {
        wasCleaned := false

        filePath := this.app.Config.AssetsDir . "\" . entityObj.Key . "\" . entityObj.Key . ".ahk"

        if (FileExist(filePath)) {
            FileDelete(filePath)
            wasCleaned := true
        }

        return wasCleaned
    }
}
