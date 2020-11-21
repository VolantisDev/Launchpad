#Include CopyableBuildFile.ahk

class ShortcutFile extends CopyableBuildFile {
    requestMessage := "Select the game shortcut"
    selectFilter := "Shortcuts (*.lnk; *.url; *.exe)"
    
    __New(app, config, launcherDir, key, filePath := "") {
        sourcePath := config.Has("shortcutSrc") ? config.shortcutSrc : ""
        super.__New(app, config, launcherDir, key, ".lnk", filePath, sourcePath)
    }

    Locate() {
        path := super.Locate()

        if (path != "") {
            SplitPath(path,,, fileExt)

            if (fileExt == "exe") {
                path := this.CreateShortcut(path)
            }
        }

        return path
    }

    CreateShortcut(path) {
        SplitPath(path,, workingDir)
        FileCreateShortcut(path, this.FilePath, workingDir)
        return this.FilePath
    }

    Copy() {
        this.DetermineExtension()
        return super.Copy()
    }

    DetermineExtension() {
        if (this.SourcePath != "") {
            SplitPath(this.SourcePath,,, sourceExt)
            SplitPath(this.FilePath,, fileDir, fileExt, fileNameNoExt)

            if (sourceExt != fileExt) {
                this.FilePath := fileDir . "\" . fileNameNoExt . "." . sourceExt
            }
        }
    }
}
