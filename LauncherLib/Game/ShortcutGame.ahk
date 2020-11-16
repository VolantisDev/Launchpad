class ShortcutGame extends Game {
    shortcut := ""
    launcherType := "Shortcut"

    __New(appDir, key, gameType, options := "") {
        if (options == "") {
            options := {}
        }

        if (options.HasKey("shortcut")) {
            this.shortcut := options.shortcut
        } else {
            shortcutBase := options.assetsDir . "\" . key

            if (FileExist(shortcutBase . ".lnk")) {
                this.shortcut := shortcutBase . ".lnk"
            }

            ; @todo Support other shortcut extensions?
        }

        base.__New(appDir, gameType, gameId)
    }

    RunGame() {
        if (this.shortcut != "") {
            Run,% this.shortcut,, Hide
        }
    }
}
