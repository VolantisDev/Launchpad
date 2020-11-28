class FileInstallerAssetBase extends InstallerAssetBase {
    destPath := ""
    recurse := true
    zipped := false

    __New(destPath, appState, stateKey, cache, parentStateKey := "", overwrite := false, tmpDir := "", onlyCompiled := false) {
        this.destPath := destPath
        super.__New(appState, stateKey, cache, parentStateKey, overwrite, tmpDir, onlyCompiled)

        if (this.zipped) {
            this.tmpFile .= ".zip"
        }
    }

    InstallAction() {
        this.CreateParentDir()

        result := this.InstallFilesAction()

        if (result and this.zipped and this.TmpFileExists()) {
            unzipResult := this.ExtractZip(true)

            if (!unzipResult) {
                result := false
            }
        }

        if (result) {
            superResult := super.InstallAction()

            if (!superResult) {
                result := false
            }
        }

        return result
    }

    CreateParentDir() {
        SplitPath(this.destPath,,destDir,,,destDrive)

        if (destDrive != "" and destDir != "" and !DirExist(destDir)) {
            DirCreate(destDir)
        }
    }

    InstallFilesAction() {
        return true
    }

    GetTmpFile() {
        return this.tmpDir . "\" . this.tmpFile
    }

    TmpFileExists() {
        return (this.tmpFile != "" and FileExist(this.GetTmpFile()))
    }

    ExtractZip(deleteZip := true) {
        static psh := ComObjCreate("Shell.Application")
        destinationPath := this.GetDestPath()

        if (!DirExist(destinationPath)) {
            DirCreate(destinationPath)
        }

        zipFile := this.tmpDir . "\" . this.tmpFile

        if (FileExist(zipFile)) {
            archiveItems := psh.Namespace(zipFile).items
            psh.Namespace(destinationPath).CopyHere(archiveItems, 4|16)

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

        return super.ExistsAction()
    }

    UninstallAction() {
        attribs := FileExist(this.destPath)

        if (InStr(attribs, "D")) {
            DirDelete(this.destPath, this.recurse)
        } else if (attribs != "") {
            FileDelete(this.destPath)
        }

        return super.UninstallAction()
    }
}
