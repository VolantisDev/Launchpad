class ShortcutGame extends Game {
    shortcut := ""
    launcherType := "Shortcut"

    __New(appDir, key, gameType, options := "") {
        if (options == "") {
            options := Map()
        }

        if (options.Has("shortcut")) {
            this.shortcut := options["shortcut"]
        } else {
            shortcutBase := options["assetsDir"] . "\" . key

            ; @todo Support other shortcut extensions?
            if (FileExist(shortcutBase . ".lnk")) {
                this.shortcut := shortcutBase . ".lnk"
            }
        }

        super.__New(appDir, key, gameType, options)
    }

    RunGame() {
        if (this.shortcut != "") {
            Run(this.shortcut,, "Hide")
        }

        return 0
    }
}
