class BuildFileBase {
    app := ""
    appDir := ""
    tempDir := ""
    destPathValue := ""
    launcherEntityObj := ""

    FilePath {
        get => this.destPathValue
        set => this.destPathValue := value
    }

    __New(launcherEntityObj, destPath) {
        InvalidParameterException.CheckTypes("BuildFileBase", "launcherEntityObj", launcherEntityObj, "LauncherEntity", "destPath", destPath, "")
        InvalidParameterException.CheckEmpty("BuildFileBase", "destPath", destPath)

        this.app := launcherEntityObj.app
        this.appDir := this.app.appDir
        this.tempDir := this.app.tmpDir . "\BuildFiles\" . launcherEntityObj.Id
        this.launcherEntityObj := launcherEntityObj
        this.destPathValue := destPath
    }

    Build() {
        throw MethodNotImplementedException("BuildFileBase", "Build")
    }

    Cleanup() {
        return true
    }

    Delete() {
        if (this.FilePath != "" && FileExist(this.FilePath)) {
            FileDelete(this.FilePath)
        }
    }
}
