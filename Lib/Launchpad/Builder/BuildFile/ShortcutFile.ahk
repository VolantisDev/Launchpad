class ShortcutFile extends CopyableBuildFile {
    requestMessage := "Select the game shortcut"
    selectFilter := "Shortcuts (*.lnk; *.url; *.exe)"
    
    __New(launcherEntityObj, destPath := "") {
        if (destPath == "") {
            ext := ".lnk"

            if (launcherEntityObj["ManagedGame"]["ShortcutSrc"] != "" && SubStr(launcherEntityObj["ManagedGame"]["ShortcutSrc"], -4) == ".url") {
                ext := ".url"
            }
            
            destPath := launcherEntityObj["AssetsDir"] . "\" . launcherEntityObj.Id . ext
        }

        super.__New(launcherEntityObj, launcherEntityObj["ManagedGame"]["ShortcutSrc"], destPath)
    }

    Locate() {
        path := super.Locate()

        if (path != "") {
            SplitPath(path,,, &fileExt)

            if (fileExt == "exe") {
                path := this.CreateShortcut(path)
            }
        }

        return path
    }

    CreateShortcut(path) {
        SplitPath(path,, &workingDir)
        FileCreateShortcut(path, this.FilePath, workingDir)
        return this.FilePath
    }

    Copy() {
        this.DetermineExtension()
        return super.Copy()
    }

    DetermineExtension() {
        if (this.SourcePath != "") {
            SplitPath(this.SourcePath,,, &sourceExt)
            SplitPath(this.FilePath,, &fileDir, &fileExt, &fileNameNoExt)

            if (sourceExt != fileExt) {
                this.FilePath := fileDir . "\" . fileNameNoExt . "." . sourceExt
            }
        }
    }
}
