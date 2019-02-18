class GameShortcut {
    key := ""
    launcherDir := ""
    shortcutPathValue := ""

    ShortcutPath[] {
        get {
            return this.shortcutPathValue
        }
        set {
            return this.shortcutPathValue := value
        }
    }

    __New(launcherDir, key, shortcutPath := "", autoPrepare := true) {
        this.launcherDir := launcherDir
        this.key := key
        this.shortcutPathValue := shortcutPathValue

        if (autoPrepare) {
            this.PrepareGameShortcut()
        }
    }

    AskGameShortcut() {
        FileSelectFile, shortcut, 1,, % this.key . ": Select the game shortcut", Shortcuts (*.lnk; *.url)
        return shortcut
    }

    CopyGameShortcut(shortcut) {
        SplitPath, shortcut,,, shortcutExt
        dest := this.launcherDir . "\" . this.key . "." . shortcutExt
        if (shortcut != dest) {
            FileCopy, %shortcut%, %dest%, true
        }
        return dest
    }

    PrepareGameShortcut() {
        if (this.shortcutPathValue == "") {
            base := this.launcherDir . "\" . this.key

            if (FileExist(base . ".lnk")) {
                this.shortcutPathValue := base . ".lnk"
            } else if (FileExist(base . ".url")) {
                this.shortcutPathValue := base . ".url"
            } else {
                this.shortcutPathValue := this.AskGameShortcut()
            }
        }

        this.shortcutPathValue := this.CopyGameShortcut(this.shortcutPathValue)
        return this.shortcutPathValue
    }
}
