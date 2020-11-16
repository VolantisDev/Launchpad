class AppConfig extends IniConfig {
    appNameValue := ""

    AppName[] {
        get {
            return this.appNameValue
        }
        set {
            return this.appNameValue := value
        }
    }

    LauncherDir[] {
        get {
            launcherDirValue := this.GetIniValue("LauncherDir")

            if (launcherDirValue == "") {
                launcherDirValue := this.app.ChangeLauncherDir()
            }

            return launcherDirValue
        }
        set {
            return this.SetIniValue("LauncherDir", value)
        }
    }

    LauncherFile[] {
        get {
            launcherFileValue := this.GetIniValue("LauncherFile")

            if (launcherFileValue == "") {
                launcherFileValue := this.app.ChangeLauncherFile()
            }
            
            return launcherFileValue
        }
        set {
            return this.SetIniValue("LauncherFile", value)
        }
    }

    AssetsDir[] {
        get {
            assetsDirValue := this.GetIniValue("AssetsDir")

            if (assetsDirValue == "") {
                assetsDirValue := this.LauncherDir
            }
            
            return assetsDirValue
        }
        set {
            return this.SetIniValue("AssetsDir", value)
        }
    }

    IndividualDirs[] {
        get {
            individualDirsValue := this.GetIniValue("IndividualDirs")

            if (individualDirsValue == "") {
                individualDirsValue := false
            }

            return individualDirsValue
        }
        set {
            return this.SetIniValue("IndividualDirs", value)
        }
    }

    CopyAssets[] {
        get {
            copyAssetsValue := this.GetIniValue("CopyAssets")

            if (copyAssetsValue == "") {
                copyAssetsValue := false
            }

            return copyAssetsValue
        }
        set {
            return this.SetIniValue("CopyAssets", value)
        }
    }
}
