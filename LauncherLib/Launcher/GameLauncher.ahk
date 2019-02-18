class GameLauncher {
    game := {}
    launcherExe := ""
    launcherShortcut := ""
    launcherName := "Launcher"
    closeLauncherBefore := false
    closeLauncherAfter := false
    runThenWait := false

    __New(game) {
        this.game := game
    }

    StartLauncher() {
        ; @todo Implement
    }

    WaitForClose() {
        Loop {
            Process, Exist, % this.LauncherExe
            If (!ErrorLevel= 0) {
                MsgBox, 5, % this.launcherName . " Running", % this.launcherName . " is currently running. Please shut it down to continue.", 5
                IfMsgBox Cancel
                    Exit
            } Else {
                Sleep, 1000
                Break
            }
        }
    }

    LaunchGame() {
        if (this.closeLauncherBefore) {
            this.WaitForClose()
        }

        this.game.RunGame()

        if (this.runThenWait) {
            this.game.WaitForClose()
        }
        
        if (this.closeLauncherAfter) {
            Sleep, 5000
            this.WaitForClose()
        }
    }

    WaitForGameToClose() {
        this.game.WaitForClose()
    }
}
