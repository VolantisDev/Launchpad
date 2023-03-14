class AboutWindow extends DialogBox {
    GetDefaultConfig(container, config) {
        defaults := super.GetDefaultConfig(container, config)
        defaults["title"] := "About " . container.GetApp().appName
        defaults["buttons"] := "*&OK"
        return defaults
    }

    Controls() {
        super.Controls()
        this.SetFont("xl", "Bold")
        this.guiObj.AddText("w" . this.windowSettings["contentWidth"], this.app.appName)
        this.SetFont("large", "Bold")
        this.guiObj.AddText("w" . this.windowSettings["contentWidth"] . " y+" . (this.margin/2), "Game Launching Multitool")
        this.SetFont("")
        version := this.app.Version

        if (version == "{{VERSION}}") {
            version := "Git"
        }

        this.guiObj.AddText("w" . this.windowSettings["contentWidth"] . " y+" . (this.margin/2),  "Version: " . version)
        text := this.app.appName . " lets you launch your games in a universally-compatible way. It was born out of frustration with trying to manage non-Steam games effectively, but it has grown since those humble origins into a full-fledged game launching multi-tool."
        text .= "`n`n" . this.app.appName . " was conceived and created by Ben McClure of Volantis Development. It is a free software project that welcomes contributions from everyone, including you!`n"
        this.guiObj.AddText("w" . this.windowSettings["contentWidth"], text)
        position := "Wrap x" . this.margin . " y+" . this.margin
        options := position . " w" . this.windowSettings["contentWidth"] . " +0x200 c" . this.themeObj.GetColor("textLink")
        this.guiObj.AddLink(options, 'Check out <a href="https://launchpad.games">launchpad.games</a>')
        this.guiObj.AddLink(options, 'Contribute to ' . this.app.appName . ' on <a href="https://github.com/VolantisDev/Launchpad">Github</a>')
        this.guiObj.AddLink(options, 'Go to <a href="https://benmcclure.com">Ben`'s homepage</a>')
        this.guiObj.AddLink(options, 'Visit Volantis Development at <a href="https://volantis.dev">volantis.dev</a>')
    }
}
