class DialogBox extends FormGuiBase {
    __New(app, themeObj, windowKey, title, text := "", owner := "", parent := "", btns := "*&Yes|&No") {
        super.__New(app, themeObj, windowKey, title, text, owner, parent, btns)
    }
}
