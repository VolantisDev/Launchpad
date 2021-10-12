class DebuggerTest extends TestBase {
    debuggerInstance := ""

    Setup() {
        super.Setup()
        this.debuggerInstance := Debugger()
    }

    Run() {
        success := super.Run()

        if (!this.TestSetLogger()) {
            success := false
        }

        if (!this.TestInspect()) {
            success := false
        }

        if (!this.TestShowMessage()) {
            succes := false
        }

        if (!this.TestLogMessage()) {
            success := false
        }

        if (!this.TestToString()) {
            success := false
        }

        if (!this.TestGetIndent()) {
            success := false
        }

        return success
    }

    TestSetLogger() {
        success := false
        this.debuggerInstance.logger := ""
        logPath := this.testDir . "\Data\log.txt"
        logger := FileLogger(logPath)
        loggerServiceObj := LoggerService(logger)

        try {
            this.debuggerInstance.SetLogger(loggerServiceObj)
        } catch Any {

        }
        this.AssertEquals("SetLogger", Type(loggerServiceObj), Type(this.debuggerInstance.logger))

        try {
            this.debuggerInstance.SetLogger(logger)
        } catch Any {

        }
        this.AssertNotEquals("SetLogger", Type(logger), Type(this.debuggerInstance.logger))

        try {
            invalidLogger := Map("Not", "a logger")
            this.debuggerInstance.SetLogger(invalidLogger)
        } catch any {

        }

        this.AssertNotEquals("SetLogger", Type(invalidLogger), Type(this.debuggerInstance.logger))
    }

    TestInspect() {
        return true
    }

    TestShowMessage() {
        return true
    }

    TestLogMessage() {
        ; TODO: Test logging with a mock somehow
        return true
    }

    TestToString() {
        val := "Test string"
        str := this.debuggerInstance.ToString(val)
        return this.AssertEquals("ToString", val, str)
    }

    TestGetIndent() {
        success := true
        indentStr := "-"

        testIndent := this.debuggerInstance.GetIndent(0, indentStr)
        if (!this.AssertEquals("GetIndent", testIndent, "")) {
            success := false
        }

        testIndent := this.debuggerInstance.GetIndent(10, indentStr)
        if (!this.AssertEquals("GetIndent", testIndent, "----------")) {
            success := false
        }

        return success
    }

    Teardown() {
        super.Teardown()
    }
}
