class DialogBox extends FormGuiBase {
    __New(title, text := "", owner := "", btns := "*&Yes|&No") {
        super.__New(title, text, owner, "", btns)
    }
}
