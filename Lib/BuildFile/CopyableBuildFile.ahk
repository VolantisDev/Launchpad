#Include BuildFile.ahk

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

    __New(app, config, launcherDir, key, extension, filePath := "", sourcePath := "") {
        this.sourcePathValue := sourcePath
        super.__New(app, config, launcherDir, key, extension, filePath)
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
            this.app.Toast("No file selected. Skipping build file.", "Launchpad", 10, 3)
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
