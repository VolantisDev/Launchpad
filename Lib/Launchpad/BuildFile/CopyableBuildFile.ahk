class CopyableBuildFile extends BuildFileBase {
    sourcePathValue := ""
    requestMessageValue := "Select the file"
    selectFilterValue := "All Files (*.*)"

    SourcePath[] {
        get => this.sourcePathValue
        set => this.sourcePathValue := value
    }

    RequestMessage[] {
        get => this.requestMessageValue
        set => this.requestMessageValue := value
    }

    SelectFilter[] {
        get => this.selectFilterValue
        set => this.selectFilterValue := value
    }

    __New(app, launcherEntityObj, launcherDir, key, extension, filePath := "", sourcePath := "") {
        InvalidParameterException.CheckTypes("BuilderBase", "app", app, "Launchpad", "sourcePath", sourcePath, "")
        this.sourcePathValue := sourcePath
        super.__New(app, launcherEntityObj, launcherDir, key, extension, filePath)
    }

    Build() {
        super.Build()
        path := this.Locate()
        result := path

        if (path != "" && path != this.FilePath) {
            this.SourcePath := path
            result := this.Copy()
        }

        this.Cleanup()

        return result
    }

    Locate() {
        path := ""

        if (this.FilePath != "" and FileExist(this.FilePath)) {
            path := this.FilePath
        } else if (this.SourcePath != "" and FileExist(this.SourcePath)) {
            path := this.SourcePath
        } else {
            path := this.AskForPath()
        }

        return path
    }

    AskForPath() {
        file := FileSelect(1,, this.key . ": " . this.RequestMessage, this.SelectFilter)
        
        if (file == "") {
            this.app.Notifications.Warning("No file selected. Skipping build file.")
        }

        return file
    }

    Copy() {
        if (this.FilePath == "" || this.SourcePath == "") {
            return false
        }

        if (this.SourcePath != this.FilePath) {
            FileCopy(this.SourcePath, this.FilePath, true)
        }

        return this.FilePath
    }
}
