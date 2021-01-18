class FileInstallerComponentBase extends InstallerComponentBase {
    destPath := ""
    recurse := true
    zipped := false
    zipFile := ""
    deleteZip := true

    __New(version, destPath, appState, stateKey, cache, parentStateKey := "", overwrite := false, tmpDir := "", onlyCompiled := false) {
        this.destPath := destPath
        super.__New(version, appState, stateKey, cache, parentStateKey, overwrite, tmpDir, onlyCompiled)

        if (this.zipped) {
            this.tmpFile .= ".zip"
        }
    }

    /**
    * ABSTRACT METHODS
    */

    InstallFilesAction() {
        throw MethodNotImplementedException.new("FileInstallerComponentBase", "InstallFilesAction")
    }

    /**
    * IMPLEMENTED METHODS
    */

    InstallAction() {
        this.CreateParentDir()

        result := this.InstallFilesAction()

        if (result && this.zipped && this.ZipFileExists()) {
            unzipResult := this.ExtractZip(this.deleteZip)

            if (!unzipResult) {
                result := false
            }
        }

        return result
    }

    CreateParentDir() {
        SplitPath(this.destPath,,destDir,,,destDrive)

        if (destDrive != "" && destDir != "" && !DirExist(destDir)) {
            DirCreate(destDir)
        }
    }

    GetTmpFile() {
        return this.tmpDir . "\" . this.tmpFile
    }

    TmpFileExists() {
        return (this.tmpFile != "" && FileExist(this.GetTmpFile()))
    }

    ZipFileExists() {
        return (this.zipFile != "" && FileExist(this.zipFile))
    }

    ExtractZip(deleteZip := true) {
        destinationPath := this.GetDestPath()

        if (!DirExist(destinationPath)) {
            DirCreate(destinationPath)
        }

        zipFile := this.zipFile

        if (FileExist(zipFile)) {
            archive := ZipArchive7z.new(zipFile)
            archive.Extract(destinationPath)

            if (deleteZip) {
                FileDelete(zipFile)
            }
        }
        
        return true
    }

    GetDestPath() {
        return this.GetAbsolutePath(this.destPath)
    }

    GetAbsolutePath(path) {
        SplitPath(path,,,,, driveLetter)

        if (driveLetter == "") {
            path := this.scriptDir . "\" . path
        }

        return path
    }

    ExistsAction() {
        if (!FileExist(this.destPath)) {
            return false
        }

        return true
    }

    UninstallAction() {
        attribs := FileExist(this.destPath)

        if (InStr(attribs, "D")) {
            DirDelete(this.destPath, this.recurse)
        } else if (attribs != "") {
            FileDelete(this.destPath)
        }

        return true
    }
}
