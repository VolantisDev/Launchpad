class DependencyBase {
    app := ""
    key := ""
    config := Map()
    path := ""
    zipped := false
    zipPath := ""
    static psh := ComObjCreate("Shell.Application")

    __New(app, key, config) {
        this.app := app
        this.key := key
        this.config := config
        this.path := app.appDir . "\Vendor\" . key
        this.zipped := config.Has("Zipped") ? config["Zipped"] : false
    }

    NeedsUpdate(force := false) {
        return (force or !this.IsInstalled())
    }

    Unzip(file) {
        DependencyBase.psh.Namespace(this.path).CopyHere(DependencyBase.psh.Namespace(file).items, 4|16)
    }

    Extract(force := false) {
        if (this.zipped and this.zipPath != "" and FileExist(this.zipPath)) {
            this.Unzip(this.zipPath)
            FileDelete(this.zipPath)
        }
    }

    IsInstalled() {
        return FileExist(this.path . "\" . this.config["MainFile"])
    }

    Install(force := false) {
        this.PreInstall(force)
        this.InstallAction(force)
        this.PostInstall(force)
    }

    PreInstall(force := false) {
        if (DirExist(this.path)) {
            DirDelete(this.path, true)
        }

        DirCreate(this.path)
    }

    InstallAction(force := false) {
        
    }

    PostInstall(force := false) {
        this.Extract(force)
    }

    Update(force := false) {
        if (this.NeedsUpdate(force)) {
            this.Install(force)
        }
    }
}
