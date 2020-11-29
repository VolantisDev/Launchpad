class LaunchpadFormGuiBase extends FormGuiBase {
    app := ""
    __New(app, title, text := "", owner := "", windowKey := "", btns := "*&Submit") {
        InvalidParameterException.CheckTypes("LauncherGameOpBase", "app", app, "Launchpad")

        this.app := app
        super.__New(title, text, owner, windowKey, btns)
    }
}
