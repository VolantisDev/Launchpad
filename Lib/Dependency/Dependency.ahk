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

    Download(force := false) {
        DirCreate(this.path)
        Download(this.config["url"], this.downloadPath)
        return this.downloadPath
    }

    Extract(force := false) {
        if (this.zipped and FileExist(this.downloadPath)) {
            this.Unzip(this.downloadPath)
            FileDelete(this.downloadPath)
        }
    }

    DownloadAssets(force := false) {
        for (key, assetConfig in this.config["assets"]) {
            if (Type(assetConfig) == "String") {
                assetConfig := Map("type", "default", "asset", key, "path", assetConfig)
            }

            assetPath := this.path . "\" . assetConfig["path"]

            if (force or !FileExist(assetPath)) {
                SplitPath(assetPath,,assetDir)
                
                if (!DirExist(assetDir)) {
                    DirCreate(assetDir)
                }

                if (assetConfig["type"] == "default" or assetConfig["type"] == "asset") {
                    asset := ApiAsset.new(this.app, assetConfig["asset"], "dependencies/" . this.key)
                    asset.Copy(assetPath)
                } else if (assetConfig["type"] == "download") {
                    Download(assetConfig["url"], assetPath)
                } else {
                    this.app.Notifications.Warning(this.key . ": Skipping asset " . key . " because it is of an unknown type.")
                }
            }
        }
    }

    IsInstalled() {
        return FileExist(this.path . "\" . this.config["mainFile"])
    }

    Install(force := false) {
        if (DirExist(this.path)) {
            DirDelete(this.path, true)
        }

        DirCreate(this.path)
        this.Download(force)
        this.Extract(force)
        this.DownloadAssets(force)
    }

    Update(force := false) {
        if (this.NeedsUpdate(force)) {
            this.Install(force)
        }
    }
}
