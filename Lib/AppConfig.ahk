class AppConfig {
    appDirValue := ""
    appNameValue := ""
    configPathValue := ""

    AppDir[] {
        get {
            return this.appDirValue
        }
        set {
            return this.appDirValue := value
        }
    }

    AppName[] {
        get {
            return this.appNameValue
        }
        set {
            return this.appNameValue := value
        }
    }

    ConfigPath[] {
        get {
            return this.configPathValue
        }
        set {
            return this.configPathValue := value
        }
    }

    LauncherDir[] {
        get {
            value := this.GetIniValue("LauncherDir")

            if (Trim(value) == "") {
                value := this.AskLauncherDir()
                this.SetIniValue("LauncherDir", value)
            }

            return value
        }
        set {
            return this.SetIniValue("LauncherDir", value)
        }
    }

    LauncherFile[] {
        get {
            value := this.GetIniValue("LauncherFile")

            if (Trim(value) == "") {
                value := this.AskLauncherFile()
                this.SetIniValue("LauncherFile", value)
            }

            return value
        }
        set {
            return this.SetIniValue("LauncherFile", value)
        }
    }

    DefaultsFile[] {
        get {
            return this.appDirValue . "\Data\GamesDB.json"
        }
    }

    __New(appName, appDir, configPath := "") {
        this.appDirValue := appDir
        this.appNameValue := appName

        if (configPath == "") {
            configPath := appDir . "\" . appName . ".ini"
        }

        this.configPathValue := configPath
    }

    GetIniValue(key, section := "General") {
        IniRead, value, % this.configPathValue, %section%, %key%, %A_Space%
        return value
    }

    SetIniValue(key, value, section := "General") {
        IniWrite, %value%, % this.configPathValue, %section%, %key%
        return value
    }

    AskLauncherDir() {
        FileSelectFolder, launcherDir,, 3, Create or select the folder to create game launchers within
        return launcherDir
    }

    AskLauncherFile() {
        FileSelectFile, filePath, 1,, Select the Launchers file, JSON Documents (*.json)
        return filePath
    }
}
