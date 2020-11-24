class AhkLauncherBuilder {
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
}
