class GameAhkFile extends ComposableBuildFile {
    __New(launcherEntityObj, destPath := "") {
        if (destPath == "") {
            destPath := launcherEntityObj.AssetsDir . "\" . launcherEntityObj.Key . ".ahk"
        }

        super.__New(launcherEntityObj, destPath)
    }

    ComposeFile() {
        global appVersion
        FileAppend("#Warn`n", this.FilePath)
        FileAppend("#Include " . this.appDir . "\Lib\Shared\Includes.ahk`n", this.FilePath)
        FileAppend("appVersion := `"" . appVersion . "`"`n", this.FilePath)
        FileAppend("gameConfig := " . this.ConvertMapToCode(this.launcherEntityObj.ManagedLauncher.ManagedGame.Config) . "`n", this.FilePath)
        FileAppend("launcherConfig := " . this.ConvertMapToCode(this.launcherEntityObj.ManagedLauncher.Config) . "`n", this.FilePath)
        FileAppend("gameObj := " . this.launcherEntityObj.ManagedLauncher.ManagedGame.EntityClass . ".new(`"" . this.launcherEntityObj.Key . "`", gameConfig, launcherConfig)`n", this.FilePath)
        FileAppend("launcherObj := " . this.launcherEntityObj.ManagedLauncher.EntityClass . ".new(`"" . this.launcherEntityObj.Key . "`", gameObj, launcherConfig)`n", this.FilePath)
        FileAppend("launcherObj.LaunchGame()`n", this.FilePath)

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
            value := "`"" . value . "`""
        }
        
        return value
    }
}
