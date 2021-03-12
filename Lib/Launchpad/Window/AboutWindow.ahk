class AboutWindow extends DialogBox {
    windowOptions := "+AlwaysOnTop"
    isDialog := true

    __New(title, themeObj, text := "", windowKey := "", owner := "", parent := "", btns := "*&Yes|&No") {
        if (title == "") {
            title := "About Launchpad"
        }

        if (text = "") {
            text := "Launchpad lets you launch your games from any platform in a universally-compatible way. It was born out of frustration with trying to manage non-Steam games effectively, but it has grown hugely since those humble origins into a full-fledged game launching multi-tool."
            text .= "`n`nLaunchpad was conceived and created by Ben McClure of Volantis Development. It is a free software project that welcomes contributions from everyone, including you!`n"        
        }
        
        super.__New(title, themeObj, text, windowKey, owner, parent, btns)
    }

    Controls() {
        super.Controls()
        position := "x" . this.margin . " y+" . this.margin
        options := position . " w" . this.windowSettings["contentWidth"] . " +0x200 c" . this.themeObj.GetColor("linkText")

        this.guiObj.AddLink(options, 'Check out <a href="https://launchpad.games">launchpad.games</a>')
        this.guiObj.AddLink(options, 'Contribute to Launchpad on <a href="https://github.com/VolantisDev/Launchpad">Github</a>')
        this.guiObj.AddLink(options, 'Go to <a href="https://benmcclure.com">Ben`'s homepage</a>')
        this.guiObj.AddLink(options, 'Visit Volantis Development at <a href="https://volantis.dev">volantis.dev</a>')
    }
}
