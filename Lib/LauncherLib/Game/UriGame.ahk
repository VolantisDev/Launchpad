class UriGame extends Game {
    uri := ""
    launcherType := "Shortcut"

    __New(appDir, key, gameType, options := "") {
        if (options == "") {
            options := Map()
        }

        if (options.Has("runCmd")) {
            this.uri := options["runCmd"]
        }
        
        super.__New(appDir, key, gameType, options)
    }

    RunGame() {
        if (this.uri != "") {
            Run(this.runCmd,, "Hide")
        }

        return super.RunGame()
    }
}
