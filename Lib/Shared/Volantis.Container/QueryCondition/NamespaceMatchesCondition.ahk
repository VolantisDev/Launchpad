class NamespaceMatchesCondition extends FieldCondition {
    serviceName := ""

    __New(serviceName, negate := false) {
        this.serviceName := serviceName
        super.__New([HasFieldCondition(this.field)], "namespace", negate, true)
    }

    EvaluateCondition(val) {
        return (InStr(this.serviceName, val) == 1)
    }
}
