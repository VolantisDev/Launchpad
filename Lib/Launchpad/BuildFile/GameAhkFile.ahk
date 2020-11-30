class GameAhkFile extends ComposableBuildFile {
    __New(app, launcherEntityObj, launcherDir, key, filePath := "") {
        super.__New(app, launcherEntityObj, launcherDir, key, ".ahk", filePath)
    }

    ComposeFile() {
        FileAppend("#Warn`n", this.FilePath)
        FileAppend("#Include " . this.appDir . "\Lib\LauncherLib\Includes.ahk`n", this.FilePath)
        FileAppend("#Include " . this.appDir . "\Lib\Shared\Includes.ahk`n", this.FilePath)
        FileAppend("gameConfig := " . this.ConvertMapToCode(this.launcherEntityObj.ManagedLauncher.ManagedGame.Config) . "`n", this.FilePath)
        FileAppend("launcherConfig := " . this.ConvertMapToCode(this.launcherEntityObj.ManagedLauncher.Config) . "`n", this.FilePath)
        FileAppend("gameObj := " . this.launcherEntityObj.ManagedLauncher.ManagedGame.EntityClass . ".new(`"" . this.key . "`", gameConfig)`n", this.FilePath)
        FileAppend("launcherObj := " . this.launcherEntityObj.ManagedLauncher.EntityClass . ".new(`"" . this.key . "`", gameObj, launcherConfig)`n", this.FilePath)
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
