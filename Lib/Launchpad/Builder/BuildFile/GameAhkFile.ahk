class GameAhkFile extends ComposableBuildFile {
    __New(launcherEntityObj, destPath := "") {
        if (destPath == "") {
            destPath := launcherEntityObj.AssetsDir . "\" . launcherEntityObj.Key . ".ahk"
        }

        super.__New(launcherEntityObj, destPath)
    }

    ComposeFile() {
        global appVersion
        launcherName := this.launcherEntityObj.Key . " - Launchpad"
        ahkVar := AhkVariable.new()

        FileAppend
        (
        ";@Ahk2Exe-SetName '" . launcherName . "'
        ;@Ahk2Exe-SetVersion '" . appVersion . "'
        ;@Ahk2Exe-SetCompanyName 'Volantis Development'
        ;@Ahk2Exe-SetCopyright 'Copyright 2021 Ben McClure'
        ;@Ahk2Exe-SetDescription 'Launchpad Game Launcher'
        #Warn

        ;DllCall('AllocConsole')
        ;WinHide('ahk_id ' . DllCall('GetConsoleWindow', 'ptr'))

        ;A_IconHidden := A_IsCompiled
        appVersion := '" . appVersion . "'
        #Include " . this.appDir . "\Lib\Shared\Includes.ahk
        #Include " . this.appDir . "\Lib\LaunchpadLauncher\Includes.ahk

        appInfo := Map()
        appInfo['appName'] := '" . launcherName . "'
        appInfo['developer'] := 'Volantis Development'
        appInfo['version'] := '" . appVersion . "'
        appInfo['configClass'] := 'LaunchpadLauncherConfig'
        appInfo['stateClass'] := 'LaunchpadLauncherState'
        appInfo['launcherKey'] := '" . this.launcherEntityObj.Key . "'
        appInfo['launchpadLauncherConfig'] := " . ahkVar.ToString(this.launcherEntityObj.Config) .  "
        appInfo['launcherConfig'] := " . ahkVar.ToString(this.launcherEntityObj.ManagedLauncher.Config) . "
        appInfo['gameConfig'] := " . ahkVar.ToString(this.launcherEntityObj.ManagedLauncher.ManagedGame.Config) . "
        
        LaunchpadLauncher.new(appInfo)
        "
        ), this.FilePath
        
        return this.FilePath
    }

    ConvertMapToCode(typeConfig) {
        code := "Map("
        empty := true

        for key, value in typeConfig {
            if (!empty) {
                code .= ", "
            }

            code .= this.ConvertValueToCode(key) . ", " . this.ConvertValueToCode(value)
            empty := false
        }

        code .= ")"

        return code
    }

    ConvertArrayToCode(typeConfig) {
        code := "["
        empty := true

        for index, value in typeConfig {
            if (!empty) {
                code .= ", "
            }

            code .= this.ConvertValueToCode(value)
            empty := false
        }

        code .= "]"

        return code
    }

    ConvertObjectToCode(typeConfig) {

        code := "{"
        empty := true

        for key, value in typeConfig {
            if (!empty) {
                code .= ", "
            }

            code .= key . ": " . this.ConvertValueToCode(value)
            empty := false
        }

        code .= "}"

        return code
    }

    ConvertValueToCode(value) {
        if (Type(value) == "Map") {
            value := this.ConvertMapToCode(value)
        } else if (Type(value) == "Array") {
            value := this.ConvertArrayToCode(value)
        } else if (IsObject(value)) {
            value := this.ConvertObjectToCode(value)
        } else if (Type(value) == "String" && value != "true" && value != "false") {
            value := StrReplace(value, "`"", "```"")
            value := "`"" . value . "`""
        }
        
        return value
    }
}
