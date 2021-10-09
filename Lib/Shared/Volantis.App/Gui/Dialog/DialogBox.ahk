class DialogBox extends FormGuiBase {
    __New(app, themeObj, guiId, title, text := "", owner := "", parent := "", btns := "*&Yes|&No") {
        super.__New(app, themeObj, guiId, title, text, owner, parent, btns)
    }
}
