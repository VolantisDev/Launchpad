class DownloadableDependency extends DependencyBase {
    downloadPath := ""

    __New(app, key, config) {
        super.__New(app, key, config)
        this.downloadPath := this.path . "\" . config["downloadFile"]
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
        Download(this.config["url"], this.downloadPath)
        return this.downloadPath
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
                    asset := DSAssetFile.new(this.app, assetConfig["asset"], this.key, "assets/dependencies")
                    asset.Copy(assetPath)
                } else if (assetConfig["type"] == "download") {
                    Download(assetConfig["url"], assetPath)
                } else {
                    this.app.Notifications.Warning(this.key . ": Skipping asset " . key . " because it is of an unknown type.")
                }
            }
        }
    }
}
