class Game {
    gameId := ""
    gameShortcut := ""
    useClass := false
    launcherType := "Shortcut"
    workingDir := A_WorkingDir
    launcherGenDir := ""

    __New(launcherGenDir, gameId, gameShortcut := "") {
        this.launcherGenDir := launcherGenDir
        this.gameId := gameId
        this.gameShortcut := gameShortcut
    }

    RunGame() {
        Run, % this.gameShortcut,, Hide
    }

    WaitForClose() {
        If (this.useClass) {
            WinWait, % "ahk_class " . this.gameId
            WinWaitClose, % "ahk_class " . this.gameId
        } Else {
            WinWait, % "ahk_exe " . this.gameId
            WinWaitClose, % "ahk_exe " . this.gameId
        }
    }
}
