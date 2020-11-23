class GameAhkFile extends ComposableBuildFile {
    __New(app, launcherGameObj, launcherDir, key, filePath := "") {
        super.__New(app, launcherGameObj, launcherDir, key, ".ahk", filePath)
    }

    ComposeFile() {
        FileAppend("#Warn`n", this.FilePath)
        FileAppend("#Include " . this.appDir . "\LauncherLib\Includes.ahk`n", this.FilePath)
        FileAppend("config := " . this.ConvertMapToCode(this.launcherGameObj.Config) . "`n", this.FilePath)
        FileAppend("gameObj := " . this.launcherGameObj.Config["gameClass"] . ".new(`"" . this.appDir . "`", `"" . this.key . "`", " . this.launcherGameObj.Config["gameType"] . ", config)`n", this.FilePath)
        FileAppend("launcherObj := " . this.launcherGameObj.Config["launcherClass"] . ".new(`"" . this.appDir . "`", `"" . this.key . "`", " . this.launcherGameObj.Config["launcherType"] . ", gameObj, config)`n", this.FilePath)
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
        if (IsObject(value)) {
            value := this.ConvertObjectToCode(value)
        } else if (Type(value) == "String" && value != "true" && value != "false") {
            value := "`"" . value . "`""
        }
        
        return value
    }
}
