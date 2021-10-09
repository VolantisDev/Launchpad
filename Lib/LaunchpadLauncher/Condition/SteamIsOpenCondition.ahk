class SteamIsOpenCondition extends SteamConditionBase {
    __New(app, negate := false) {
        this.app := app
        this.steamPath := this.GetSteamPath(app)
        super.__New("", negate)
    }

    EvaluateCondition() {
        matches := false

        if (super.EvaluateCondition()) {
            matches := (this.steamPath && DirExist(this.steamPath))
        }

        if (matches) {
            matches := !!(WinExist("ahk_class vguiPopupWindow ahk_exe Steam.exe"))
        }

        return matches
    }
}
