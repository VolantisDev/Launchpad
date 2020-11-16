class ShortcutGame extends Game {
    shortcut := ""
    launcherType := "Shortcut"

    __New(appDir, key, gameType, shortcut, options := {}) {
        this.shortcut := shortcut
        base.__New(appDir, gameType, gameId)
    }

    RunGame() {
        if (this.shortcut != "") {
            Run,% this.shortcut,, Hide
        }
    }
}
