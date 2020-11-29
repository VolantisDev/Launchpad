class BuildFileBase {
    app := ""
    appDir := ""
    tempDir := ""
    filePathValue := ""
    key := ""
    extension := ""
    launcherDir := ""
    launcherEntityObj := ""

    FilePath[] {
        get => this.filePathValue
        set => this.filePathValue := value
    }

    __New(app, launcherEntityObj, launcherDir, key, extension, filePath := "") {
        InvalidParameterException.CheckTypes("BuildFileBase", "app", app, "Launchpad", "launcherEntityObj", launcherEntityObj, "LauncherEntity", "launcherDir", launcherDir, "", "key", key, "", "extension", extension, "", "filePath", filePath, "")
        InvalidParameterException.CheckEmpty("BuildFileBase", "LauncherDir", launcherDir)

        this.app := app
        this.appDir := app.Config.AppDir
        this.tempDir := app.Config.TempDir . "\BuildFiles\" . key
        this.launcherEntityObj := launcherEntityObj
        this.launcherDir := launcherDir
        this.key := key
        this.extension := extension
        this.filePathValue := filePath

        if (this.FilePath == "") {
            this.FilePath := this.launcherDir . "\" . this.key . this.extension
        }
    }

    Build() {
        return this.FilePath
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
