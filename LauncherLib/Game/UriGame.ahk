class UriGame extends Game {
    uri := ""
    launcherType := "Shortcut"

    __New(appDir, key, gameType, options := "") {
        if (options == "") {
            options := {}
        }

        if (options.HasKey("uri")) {
            this.uri := uri
        }
        
        base.__New(appDir, gameType, gameId)
    }

    RunGame() {
        if (this.uri != "") {
            Run,% this.uri,, Hide
        }
    }
}
