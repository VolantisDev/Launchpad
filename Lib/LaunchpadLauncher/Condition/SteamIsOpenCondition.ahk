class SteamIsOpenCondition extends SteamConditionBase {
    EvaluateCondition() {
        if (!super.EvaluateCondition()) {
            return false
        }

        if (!this.steamPath || !DirExist(this.steamPath)) {
            return false
        }

        return !!(WinExist("ahk_class vguiPopupWindow ahk_exe Steam.exe"))
    }
}
