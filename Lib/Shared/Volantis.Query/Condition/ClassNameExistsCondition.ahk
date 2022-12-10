class ClassNameExistsCondition extends ConditionBase {
    EvaluateCondition(val) {
        return IsSet(val) && HasMethod(%val%)
    }
}
