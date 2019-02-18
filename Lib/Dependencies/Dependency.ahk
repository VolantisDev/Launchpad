class Dependency {
    name := ""
    mainFile := ""
    url := ""
    downloadFile := "download.zip"
    appDir := ""
    path := ""
    

    __New(appDir) {
        this.appDir := appDir
        this.path := this.appDir . "\Vendor\" . this.name
    }

    NeedsUpdate() {
        return !FileExist(this.path . "\" . this.mainFile)
    }

    Unzip(downloadFile) {
        psh := ComObjCreate("Shell.Application")
        psh.Namespace(this.path).CopyHere(psh.Namespace(downloadFile).items, 4|16)
    }

    Download() {
        FileCreateDir, % this.path
        downloadDestination := this.path . "\" . this.downloadFile
        UrlDownloadToFile, % this.url, %downloadDestination%
        this.Unzip(downloadDestination)
        FileDelete, %downloadDestination%
    }
}
