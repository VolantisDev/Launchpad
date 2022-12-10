class IsHotkeyCondition extends ConditionBase {
    EvaluateCondition(val) {
        ; @todo Actually check if this hotkey will work
        return (Type(val) == "String" && val)
    }
}
