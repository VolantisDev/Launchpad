class AboutWindow extends DialogBox {
    windowOptions := "+AlwaysOnTop"
    isDialog := true

    __New(app, themeObj, windowKey, text := "", owner := "", parent := "", btns := "*&OK") {
        if (text = "") {
            text := app.appName . " lets you launch your games from any platform in a universally-compatible way. It was born out of frustration with trying to manage non-Steam games effectively, but it has grown hugely since those humble origins into a full-fledged game launching multi-tool."
            text .= "`n`n" . app.appName . " was conceived and created by Ben McClure of Volantis Development. It is a free software project that welcomes contributions from everyone, including you!`n"        
        }
        
        super.__New(app, themeObj, windowKey, "About " . app.appName, text, owner, parent, btns)
    }

    Controls() {
        super.Controls()
        position := "x" . this.margin . " y+" . this.margin
        options := position . " w" . this.windowSettings["contentWidth"] . " +0x200 c" . this.themeObj.GetColor("linkText")

        this.guiObj.AddLink(options, 'Check out <a href="https://launchpad.games">launchpad.games</a>')
        this.guiObj.AddLink(options, 'Contribute to ' . this.app.appName . ' on <a href="https://github.com/VolantisDev/Launchpad">Github</a>')
        this.guiObj.AddLink(options, 'Go to <a href="https://benmcclure.com">Ben`'s homepage</a>')
        this.guiObj.AddLink(options, 'Visit Volantis Development at <a href="https://volantis.dev">volantis.dev</a>')
    }
}
