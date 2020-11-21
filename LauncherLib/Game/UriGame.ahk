class UriGame extends Game {
    uri := ""
    launcherType := "Shortcut"

    __New(appDir, key, gameType, options := "") {
        if (options == "") {
            options := Map()
        }

        if (options.Has("uri")) {
            this.uri := options["uri"]
        }
        
        super.__New(appDir, key, gameType, options)
    }

    RunGame() {
        if (this.uri != "") {
            Run(this.uri,, "Hide")
        }

        return 0
    }
}
