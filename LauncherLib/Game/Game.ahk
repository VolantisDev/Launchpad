class Game {
    appDir := ""
    key := ""
    name := ""
    gameType := {}
    launcherType := "Game"
    options := {}

    __New(appDir, key, gameType, options := "") {
        if (options == "") {
            options := {}
        }

        this.appDir := appDir
        this.key := key
        this.name := key
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
            WinWait, % "ahk_class " . this.options.gameId
            WinWaitClose, % "ahk_class " . this.options.gameId
        } Else {
            WinWait, % "ahk_exe " . this.options.gameId
            WinWaitClose, % "ahk_exe " . this.options.gameId
        }
    }
}
