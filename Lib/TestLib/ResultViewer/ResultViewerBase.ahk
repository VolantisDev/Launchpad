class ResultViewerBase {
    debugger := ""
    testTitle := "Application Test"

    SetTitle(title) {
        this.testTitle := title
        return this
    }

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
