class CopyableBuildFile extends BuildFile {
    sourcePathValue := ""
    requestMessageValue := "Select the file"
    selectFilterValue := "All Files (*.*)"

    SourcePath[] {
        get {
            return this.sourcePathValue
        }
        set {
            this.sourcePathValue := value
        }
    }

    RequestMessage[] {
        get {
            return this.requestMessageValue
        }
        set {
            this.requestMessageValue := value
        }
    }

    SelectFilter[] {
        get {
            return this.selectFilterValue
        }
        set {
            this.selectFilterValue := value
        }
    }

    __New(app, config, launcherDir, key, extension, filePath := "", autoBuild := true, sourcePath := "") {
        this.sourcePathValue := sourcePath
        base.__New(app, config, launcherDir, key, extension, filePath, autoBuild)
    }

    Build() {
        base.Build()

        path := this.Locate()

        if (path != "" && path != this.FilePath) {
            this.SourcePath := path
            this.Copy()
        }

        this.Cleanup()
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
        FileSelectFile, file, 1,, % this.key . ": " . this.RequestMessage, % this.SelectFilter
        
        if (file == "") {
            MsgBox, "No file selected."
            ExitApp, -1
        }

        return file
    }

    Copy() {
        if (this.FilePath != "" and this.SourcePath != "" and this.SourcePath != this.FilePath) {
            FileCopy, % this.SourcePath, % this.FilePath, true
        }
    }
}
