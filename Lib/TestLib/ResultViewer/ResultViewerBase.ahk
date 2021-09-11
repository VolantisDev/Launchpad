class ResultViewerBase {
    debugger := ""

    __New() {
        this.debugger := Debugger()
    }

    ViewResults(results) {
        throw MethodNotImplementedException("ResultViewerBase", "ViewResults")
    }

    ConvertToString(value) {
        return this.debugger.ToString(value)
    }
}
