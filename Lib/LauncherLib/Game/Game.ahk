class Game {
    appDir := ""
    key := ""
    name := ""
    gameType := ""
    launcherType := "Game"
    options := Map()

    __New(appDir, key, gameType, options := "") {
        if (options == "") {
            options := Map()
        }

        this.appDir := appDir
        this.key := key
        this.name := key
        this.gameType := gameType

        if (!options.Has("useAhkClass")) {
            options["useAhkClass"] := false
        }

        if (!options.Has("workingDir")) {
            options["workingDir"] := A_WorkingDir
        }

        this.options := options
    }

    CountRunSteps() {
        runSteps := 1 ; The run command

        ; @todo add additional steps

        return runSteps
    }

    RunGame(progress := "") {
        if (this.options["runThenWait"]) {
            this.game.WaitForClose()
        }
    }

    WaitForClose() {
        If (this.options["useAhkClass"]) {
            WinWait("ahk_class " . this.options["gameId"])
            WinWaitClose("ahk_class " . this.options["gameId"])
        } Else {
            WinWait("ahk_exe " . this.options["gameId"])
            WinWaitClose("ahk_exe " . this.options["gameId"])
        }
    }
}
