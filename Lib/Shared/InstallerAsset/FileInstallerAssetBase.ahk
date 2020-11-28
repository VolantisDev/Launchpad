class FileInstallerAssetBase extends InstallerAssetBase {
    destPath := ""
    recurse := true
    zipped := false

    __New(destPath, appState, stateKey, parentStateKey := "", overwrite := false, tmpDir := "") {
        this.destPath := destPath
        super.__New(appState, stateKey, parentStateKey, overwrite, tmpDir)
    }

    Install() {
        this.CreateParentDir()
        result := this.InstallAction()

        if (result and this.zipped and this.tmpFile != "") {
            unzipResult := this.ExtractZip(true)

            if (!unzipResult) {
                result := false
            }
        }

        return super.Install()
    }

    InstallAction() {
        return true
    }

    Exists() {
        if (!FileExist(this.destPath)) {
            return false
        }

        return super.Exists()
    }

    GetDestPath() {
        destPath := this.destPath
        SplitPath(destPath,,,,, driveLetter)

        if (driveLetter == "") {
            destPath := this.scriptPath . "\" . destPath
        }

        return destPath
    }

    Uninstall() {
        attribs := FileExist(this.destPath)

        if (InStr(attribs, "D")) {
            DirDelete(this.destPath, this.recurse)
        } else if (attribs != "") {
            FileDelete(this.destPath)
        }

        return super.Uninstall()
    }

    CreateParentDir() {
        SplitPath(this.destPath,,destDir)

        if (!DirExist(destDir)) {
            DirCreate(destDir))
        }
    }

    ExtractZip(deleteZip := true) {
        static psh := ComObjCreate("Shell.Application")
        destinationPath := this.GetDestPath()
        archiveItems := psh.Namespace(this.archiveFile).items
        psh.Namespace(destinationPath).CopyHere(archiveItems, 4|16)

        if (deleteZip) {
            FileDelete(tmpFile)
        }

        return true
    }
}
