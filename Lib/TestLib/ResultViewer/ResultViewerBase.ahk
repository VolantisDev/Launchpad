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
        throw NotImplementedTestException("The ViewResults method has not been implemented.")
    }

    ConvertToString(value) {
        return this.debugger.ToString(value)
    }
}
