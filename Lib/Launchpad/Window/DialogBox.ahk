class DialogBox extends FormWindow {
    __New(app, title, text := "", owner := "", btns := "*&Yes|&No") {
        super.__New(app, title, text, owner, "", btns)
    }
}
