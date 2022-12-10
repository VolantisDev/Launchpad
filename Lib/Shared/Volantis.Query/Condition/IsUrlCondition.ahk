class IsUrlCOndition extends ConditionBase {
    pattern := ""

    __New(pattern := "", absolute := true, negate := false) {
        if (!pattern) {
            pattern := absolute
                ? "^(https?://|www\.)[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(/\S*)?$"
                : "^(/\S*)?$" ; @todo Make this check better

        }

        this.pattern := pattern
        this.absolute := !!absolute
        super.__New("", negate)
    }

    EvaluateCondition(value) {
        return !!(RegExMatch(value, this.pattern))
    }
}
