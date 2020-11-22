class DialogBox extends FormWindow {
    __New(app, title, text := "", owner := "", buttons := "*&Yes|&No") {
        super.__New(app, title, text, owner, "", buttons)
    }
}
