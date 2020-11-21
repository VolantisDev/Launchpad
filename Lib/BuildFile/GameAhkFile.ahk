class GameAhkFile extends ComposableBuildFile {
    __New(app, config, launcherDir, key, filePath := "") {
        super.__New(app, config, launcherDir, key, ".ahk", filePath)
    }

    ComposeFile() {
        FileAppend("#Warn`n", this.FilePath)
        FileAppend("#Include " . this.appDir . "\LauncherLib\Includes.ahk`n", this.FilePath)
        FileAppend("config := " . this.ConvertObjectToCode(this.config) . "`n", this.FilePath)
        FileAppend("gameObj := " . this.config["gameClass"] . ".new(`"" . this.appDir . "`", `"" . this.key . "`", `"" . this.config["gameType"] . "`", config)`n", this.FilePath)
        FileAppend("launcherObj := " . this.config["launcherClass"] . ".new(`"" . this.appDir . "`", `"" . this.key . "`", `"" . this.config["launcherType"] . "`", gameObj, config)`n", this.FilePath)
        FileAppend("launcherObj.LaunchGame()`n", this.FilePath)

        return this.FilePath
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
        } else if (!IsNumber(value)) {
            value := "`"" . value . "`""
        }
        
        return value
    }
}
