class LaunchpadFormGuiBase extends FormGuiBase {
    app := ""
    
    __New(app, title, text := "", windowKey := "", owner := "", parent := "", btns := "*&Submit") {
        InvalidParameterException.CheckTypes("LauncherGameOpBase", "app", app, "Launchpad")
        this.app := app
        super.__New(title, app.Themes.GetTheme(), text, windowKey, owner, parent, btns)
    }
}
