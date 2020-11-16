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
        FileAppend, % "gameType := " . this.ConvertObjectToCode(this.config.gameTypeConfig) . "`n", % this.FilePath
        FileAppend, % "gameObj := new " . this.config.gameClass . "(gameType, """ . this.appDir . """, """ . this.config.GameId . """)`n", % this.FilePath
        FileAppend, % "gameObj.shortcut := """ . this.config.Shortcut . """`n", % this.FilePath
        FileAppend, % "gameObj.workingDir := """ . this.config.WorkingDir . """`n", % this.FilePath
        FileAppend, % "gameObj.useClass := " . (this.config.UseClass ? "true" : "false") . "`n`n", % this.FilePath
        FileAppend, % "launcherType := " . this.ConvertObjectToCode(this.config.launcherConfig) . "`n", % this.FilePath
        FileAppend, % "launcherObj := new " . this.config.launcherClass . "(launcherType, gameObj)`n", % this.FilePath
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
