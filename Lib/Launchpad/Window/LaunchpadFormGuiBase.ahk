class FormWindowBase extends FormGuiBase {
    app := ""
    __New(app, title, text := "", owner := "", windowKey := "", btns := "*&Submit") {
        this.app := app
        super.__New(title, text, owner, windowKey, btns)
    }
}
