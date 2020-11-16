class ShortcutGame extends Game {
    uri := ""
    launcherType := "Shortcut"

    __New(appDir, key, gameType, uri, options := {}) {
        this.uri := uri
        base.__New(appDir, gameType, gameId)
    }

    RunGame() {
        if (this.uri != "") {
            Run,% this.uri,, Hide
        }
    }
}
