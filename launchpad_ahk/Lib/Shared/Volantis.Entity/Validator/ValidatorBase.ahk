class ValidatorBase extends ConditionBase {
    errors := []

    Validate(value, args*) {
        this.errors := []
        isValid := this.Evaluate(value, args*)

        return Map(
            "valid", isValid,
            "errors", this.errors
        )
    }
}
