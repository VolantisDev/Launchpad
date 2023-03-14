class NsisInstallerBuilder extends AppBuilderBase {
    name := "Installer"

    Build(version) {
        distDir := this.app.Config["dist_dir"]

        this.ResetDistDir(distDir)
        this.BuildInstaller(distDir)

        exists := !!(FileExist(distDir . "\" . this.app.appName . "-" . this.app.Version . ".exe"))

        if (exists && this.app.Config["open_dist_dir"]) {
            Sleep(1000)
            Run(distDir)
        }
        
        return exists
    }

    ResetDistDir(distDir) {
        if (DirExist(distDir)) {
            DirDelete(distDir, true)
        }

        DirCreate(distDir)
    }

    BuildInstaller(distDir) {
        RunWait(this.app.Config["makensis"] . " /DVERSION=" . this.app.Version . ".0 " . this.app.appName . ".nsi", this.app.appDir)

        if (FileExist(distDir . "\" . this.app.appName . "Installer.exe")) {
            FileMove(distDir . "\" . this.app.appName . "Installer.exe", distDir . "\" . this.app.appName . "-" . this.app.Version . ".exe")
        }
    }
}
