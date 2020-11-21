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
            returnVal := this.GetIniValue("LauncherDir")

            if (returnVal == "") {
                returnVal := this.app.ChangeLauncherDir()
            }

            return returnVal
        }
        set {
            return this.SetIniValue("LauncherDir", value)
        }
    }

    LauncherFile[] {
        get {
            returnVal := this.GetIniValue("LauncherFile")

            if (returnVal == "") {
                returnVal := this.app.ChangeLauncherFile()
            }
            
            return returnVal
        }
        set {
            return this.SetIniValue("LauncherFile", value)
        }
    }

    AssetsDir[] {
        get {
            returnVal := this.GetIniValue("AssetsDir")

            if (returnVal == "") {
                returnVal := this.LauncherDir
            }
            
            return returnVal
        }
        set {
            return this.SetIniValue("AssetsDir", value)
        }
    }

    TempDir[] {
        get {
            returnVal := this.GetIniValue("TempDir")

            if (returnVal == "") {
                returnVal := A_Temp . "\Launchpad"
            }
            
            return returnVal
        }
        set {
            return this.SetIniValue("TempDir", value)
        }
    }

    CacheDir[] {
        get {
            returnVal := this.GetIniValue("CacheDir")

            if (returnVal == "") {
                returnVal := this.TempDir . "\Cache"
            }
            
            return returnVal
        }
        set {
            return this.SetIniValue("CacheDir", value)
        }
    }

    UpdateExistingLaunchers[] {
        get {
            returnVal := this.GetIniValue("UpdateExistingLaunchers")

            if (returnVal == "") {
                returnVal := true
            }

            return returnVal
        }
        set {
            return this.SetIniValue("UpdateExistingLaunchers", value)
        }
    }

    IndividualDirs[] {
        get {
            returnVal := this.GetIniValue("IndividualDirs")

            if (returnVal == "") {
                returnVal := false
            }

            return returnVal
        }
        set {
            return this.SetIniValue("IndividualDirs", value)
        }
    }

    CopyAssets[] {
        get {
            returnVal := this.GetIniValue("CopyAssets")

            if (returnVal == "") {
                returnVal := false
            }

            return returnVal
        }
        set {
            return this.SetIniValue("CopyAssets", value)
        }
    }

    CleanLaunchersOnBuild[] {
        get {
            returnVal := this.GetIniValue("CleanLaunchersOnBuild")

            if (returnVal == "") {
                returnVal := true
            }

            return returnVal
        }
        set {
            return this.SetIniValue("CleanLaunchersOnBuild", value)
        }
    }

    CleanLaunchersOnExit[] {
        get {
            returnVal := this.GetIniValue("CleanLaunchersOnExit")

            if (returnVal == "") {
                returnVal := false
            }

            return returnVal
        }
        set {
            return this.SetIniValue("CleanLaunchersOnExit", value)
        }
    }

    FlushCacheOnExit[] {
        get {
            returnVal := this.GetIniValue("FlushCacheOnExit")

            if (returnVal == "") {
                returnVal := false
            }

            return returnVal
        }
        set {
            return this.SetIniValue("FlushCacheOnExit", value)
        }
    }

    ApiEndpoint[] {
        get {
            returnVal := this.GetIniValue("ApiEndpoint")

            if (returnVal == "") {
                returnVal := "https://benmcclure.com/launcher-db"
            }

            return returnVal
        }
        set {
            return this.SetIniValue("ApiEndpoint", value)
        }
    }
}
