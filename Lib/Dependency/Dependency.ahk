class Dependency {
    app := ""
    key := ""
    config := Map()
    path := ""
    downloadPath := ""
    zipped := true

    __New(app, key, config) {
        this.app := app
        this.key := key
        this.config := config
        this.path := app.appDir . "\Vendor\" . key
        this.downloadPath := this.path . "\" . config["downloadFile"]
    }

    NeedsUpdate(force := false) {
        return (force or !this.IsInstalled())
    }

    Unzip(file) {
        psh := ComObjCreate("Shell.Application")
        psh.Namespace(this.path).CopyHere(psh.Namespace(file).items, 4|16)
    }

    Download() {
        DirCreate(this.path)
        Download(this.config["url"], this.downloadPath)
        return this.downloadPath
    }

    Extract() {
        if (this.zipped and FileExist(this.downloadPath)) {
            this.Unzip(this.downloadPath)
            FileDelete(this.downloadPath)
        }
    }

    DownloadAssets() {
        for apiPath, localPath in this.config["assets"] {
            asset := ApiAsset.new(this.app, apiPath, "dependencies/" . this.key)
            asset.Copy(this.path . "\" . localPath)
        }
    }

    IsInstalled() {
        return FileExist(this.path . "\" . this.config["mainFile"])
    }

    Install() {
        DirCreate(this.path)
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
