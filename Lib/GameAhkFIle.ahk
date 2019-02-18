class GameAhkFile {
    appDir := ""
    launcherDir := ""
    key := ""
    ahkPathValue := ""
    gameConfig := {}

    AhkPath[] {
        get {
            return this.ahkPathValue
        }
        set {
            return this.ahkPathValue := value
        }
    }

    __New(appDir, launcherDir, key, gameConfig, autoCreate := true) {
        this.appDir := appDir
        this.launcherDir := launcherDir
        this.key := key
        this.gameConfig := gameConfig

        this.ahkPathValue := launcherDir . "\" . key . ".ahk"

        if (autoCreate) {
            this.CreateAhkFile()
        }
    }

    DeleteAhkFile() {
        FileDelete, % this.ahkPathValue
    }

    CreateAhkFile() {
        this.DeleteAhkFile()

        FileAppend, % "#NoEnv`n", % this.ahkPathValue
        FileAppend, % "#Warn`n", % this.ahkPathValue
        FileAppend, % "SendMode Input`n", % this.ahkPathValue
        FileAppend, % "SetWorkingDir %A_ScriptDir%`n`n", % this.ahkPathValue
        if (this.gameConfig.LauncherType != "GameLauncher") {
            FileAppend, % "#Include " . this.appDir . "\LauncherLib\Launcher\GameLauncher.ahk`n", % this.ahkPathValue
        }
        FileAppend, % "#Include " . this.appDir . "\LauncherLib\Launcher\" . this.gameConfig.LauncherType . ".ahk`n", % this.ahkPathValue
        if (this.gameCOnfig.GameType != "Game") {
            FileAppend, % "#Include " . this.appDir . "\LauncherLib\Game\Game.ahk`n`n", % this.ahkPathValue
        }
        FileAppend, % "#Include " . this.appDir . "\LauncherLib\Game\" . this.gameConfig.GameType . ".ahk`n`n", % this.ahkPathValue
        FileAppend, % "gameObj := new " . this.gameConfig.GameType . "(""" . this.appDir . """, """ . this.gameConfig.GameId . """)`n", % this.ahkPathValue
        FileAppend, % "gameObj.gameShortcut := """ . this.gameConfig.GameShortcut . """`n", % this.ahkPathValue
        FileAppend, % "gameObj.workingDir := """ . this.gameConfig.workingDir . """`n", % this.ahkPathValue
        FileAppend, % "gameObj.useClass := " . (this.gameConfig.useClass ? "true" : "false") . "`n`n", % this.ahkPathValue
        FileAppend, % "launcherObj := new " . this.gameConfig.LauncherType . "(gameObj)`n", % this.ahkPathValue
        FileAppend, % "launcherObj.LaunchGame()`n", % this.ahkPathValue
    }
}
