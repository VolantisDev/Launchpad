class GameAhkFile extends ComposableBuildFile {
    __New(app, config, launcherDir, key, filePath := "", autoBuild := true) {
        base.__New(app, config, launcherDir, key, ".ahk", filePath, autoBuild)
    }

    ComposeFile() {
        FileAppend, % "#NoEnv`n", % this.FilePath
        FileAppend, % "#Warn`n", % this.FilePath
        FileAppend, % "SendMode Input`n", % this.FilePath
        FileAppend, % "SetWorkingDir %A_ScriptDir%`n`n", % this.FilePath
        FileAppend, % "#Include " . this.appDir . "\LauncherLib\Includes.ahk`n", % this.FilePath
        FileAppend, % "config := " . this.ConvertObjectToCode(this.config) . "`n", % this.FilePath
        FileAppend, % "gameObj := new " . this.config.gameClass . "(""" . this.appDir . """, """ . this.key . """, """ . this.config.gameType . """, config)`n", % this.FilePath
        FileAppend, % "launcherObj := new " . this.config.launcherClass . "(""" . this.appDir . """, """ . this.key . """, """ . this.config.launcherType . """, gameObj, config)`n", % this.FilePath
        FileAppend, % "launcherObj.LaunchGame()`n", % this.FilePath
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
        } else if value is not number 
            value := """" . value . """"

        return value
    }
}
