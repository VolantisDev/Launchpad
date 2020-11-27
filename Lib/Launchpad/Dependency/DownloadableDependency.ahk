class DownloadableDependency extends DependencyBase {
    downloadPath := ""

    __New(app, key, config) {
        super.__New(app, key, config)
        this.downloadPath := this.path . "\" . config["DownloadFile"]

        if (this.zipped) {
            this.zipPath := this.downloadPath
        }
    }

    InstallAction(force := false) {
        super.InstallAction(force)
        this.Download(force)
    }

    PostInstall(force := false) {
        super.PostInstall(force)
        this.DownloadAssets(force)
    }

    Download(force := false) {
        DirCreate(this.path)
        Download(this.config["Url"], this.downloadPath)
        return this.downloadPath
    }

    DownloadAssets(force := false) {
        for (key, assetConfig in this.config["Assets"]) {
            if (Type(assetConfig) == "String") {
                assetConfig := Map("Type", "Default", "Asset", key, "Path", assetConfig)
            }

            assetPath := this.path . "\" . assetConfig["Path"]

            if (force or !FileExist(assetPath)) {
                SplitPath(assetPath,,assetDir)
                
                if (!DirExist(assetDir)) {
                    DirCreate(assetDir)
                }

                if (assetConfig["Type"] == "Default" or assetConfig["Type"] == "Asset") {
                    asset := DSAssetFile.new(this.app, assetConfig["Asset"], "Assets/Dependencies/" . this.key)
                    asset.Copy(assetPath)
                } else if (assetConfig["Type"] == "Download") {
                    Download(assetConfig["Url"], assetPath)
                } else {
                    this.app.Notifications.Warning(this.key . ": Skipping asset " . this.key . " because it is of an unknown type.")
                }
            }
        }
    }
}
