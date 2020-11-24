class DependencyBase {
    app := ""
    key := ""
    config := Map()
    path := ""
    zipped := false

    __New(app, key, config) {
        this.app := app
        this.key := key
        this.config := config
        this.path := app.appDir . "\Vendor\" . key
        this.zipped := config.Has("zipped") ? config["zipped"] : false
    }

    NeedsUpdate(force := false) {
        return (force or !this.IsInstalled())
    }

    Unzip(file) {
        psh := ComObjCreate("Shell.Application")
        psh.Namespace(this.path).CopyHere(psh.Namespace(file).items, 4|16)
    }

    Extract(force := false) {
        if (this.zipped and FileExist(this.downloadPath)) {
            this.Unzip(this.downloadPath)
            FileDelete(this.downloadPath)
        }
    }

    IsInstalled() {
        return FileExist(this.path . "\" . this.config["mainFile"])
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
