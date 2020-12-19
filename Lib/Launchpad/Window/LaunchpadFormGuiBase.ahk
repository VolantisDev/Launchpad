class LaunchpadFormGuiBase extends FormGuiBase {
    app := ""
    
    __New(app, title, text := "", windowKey := "", owner := "", parent := "", btns := "*&Submit") {
        InvalidParameterException.CheckTypes("LaunchpadFormGuiBase", "app", app, "Launchpad")
        this.app := app

         if (Type(owner) == "String") {
            owner := app.Windows.GetGuiObj(owner)
        }

        if (Type(parent) == "String") {
            parent := app.Windows.GetGuiObj(parent)
        }
        
        super.__New(title, app.Themes.GetItem(), text, windowKey, owner, parent, btns)
    }
}
