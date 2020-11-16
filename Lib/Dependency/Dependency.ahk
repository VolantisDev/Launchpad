class Dependency {
    app := {}
    key := ""
    config := {}
    path := ""
    downloadPath := ""
    zipped := true

    __New(app, key, config) {
        this.app := app
        this.key := key
        this.config := config
        this.path := app.appDir . "\Vendor\" . key
        this.downloadPath := this.path . "\" . config.downloadFile
    }

    NeedsUpdate(force := false) {
        return (force or !this.IsInstalled())
    }

    Unzip(file) {
        psh := ComObjCreate("Shell.Application")
        psh.Namespace(this.path).CopyHere(psh.Namespace(file).items, 4|16)
    }

    Download() {
        FileCreateDir, % this.path
        UrlDownloadToFile, % this.config.url, % this.downloadPath
        return this.downloadPath
    }

    Extract() {
        if (this.zipped) {
            this.Unzip(this.downloadPath)
            FileDelete, % this.downloadPath
        }
    }

    DownloadAssets() {
        for apiPath, localPath in this.config.assets {
            asset := new ApiAsset(this.app, apiPath, "dependencies/" . this.key)
            asset.Copy(this.path . "\" . localPath)
        }
    }

    IsInstalled() {
        return FileExist(this.path . "\" . this.config.mainFile)
    }

    Install() {
        FileCreateDir, % this.path
        this.Download()
        this.Extract()
        this.DownloadAssets()
    }

    Update(force := false) {
        if (this.NeedsUpdate(force)) {
            this.Install()
        }
    }
}
