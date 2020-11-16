class Game {
    appDir := ""
    key := ""
    name := ""
    gameType := {}
    launcherType := "Game"
    options := {}

    __New(appDir, key, gameType, options := {}) {
        this.appDir := appDir
        this.key := key
        this.gameType := gameType

        if (!options.hasKey("useAhkClass")) {
            options.useAhkClass := false
        }

        if (!options.hasKey("workingDir")) {
            options.workingDir := A_WorkingDir
        }

        this.options := options
    }

    RunGame() {
    }

    WaitForClose() {
        If (this.options.useAhkClass) {
            WinWait, % "ahk_class " . this.gameId
            WinWaitClose, % "ahk_class " . this.gameId
        } Else {
            WinWait, % "ahk_exe " . this.gameId
            WinWaitClose, % "ahk_exe " . this.gameId
        }
    }
}
