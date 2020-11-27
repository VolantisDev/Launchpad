class BuildFileBase {
    app := ""
    appDir := ""
    tempDir := ""
    filePathValue := ""
    key := ""
    extension := ""
    launcherDir := ""
    launcherGameObj := ""

    FilePath[] {
        get => this.filePathValue
        set => this.filePathValue := value
    }

    __New(app, launcherGameObj, launcherDir, key, extension, filePath := "") {
        this.app := app
        this.appDir := app.Config.AppDir
        this.tempDir := app.Config.TempDir . "\BuildFiles\" . key
        this.launcherGameObj := launcherGameObj
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
