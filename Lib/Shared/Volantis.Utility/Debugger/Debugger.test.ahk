class DebuggerTest extends TestBase {
    debuggerInstance := ""

    Setup() {
        ; super.Setup()
        this.debuggerInstance := Debugger()
    }

    RunTestSteps() {
        this.TestSetLogger()
        this.TestToString()
        this.TestGetIndent()
    }

    TestSetLogger() {
        this.TestMethod := "SetLogger"

        this.debuggerInstance.logger := ""
        logPath := this.testDir . "\Data\log.txt"
        logger := FileLogger(logPath)
        loggerServiceObj := LoggerService(logger)

        try {
            this.debuggerInstance.SetLogger(loggerServiceObj)
        } catch Any {
        }

        this.AssertEquals(
            Type(loggerServiceObj), 
            Type(this.debuggerInstance.logger),
            "LoggerService replaces logger"
        )

        try {
            this.debuggerInstance.SetLogger(logger)
        } catch Any {
        }

        this.AssertNotEquals(
            Type(logger), 
            Type(this.debuggerInstance.logger),
            "Logger does not replace logger"
        )

        try {
            invalidLogger := Map("Not", "a logger")
            this.debuggerInstance.SetLogger(invalidLogger)
        } catch any {
        }

        this.AssertNotEquals(
            Type(invalidLogger),
            Type(this.debuggerInstance.logger),
            "Invalid parameter does not replace logger",
        )

        this.TestMethod := ""
    }

    TestToString() {
        this.TestMethod := "ToString"

        this.AssertEquals(
            "`"Test string`"", 
            this.debuggerInstance.ToString("Test string"),
            "Passing a string wraps it in quotes"
        )

        testString := "Test string"

        this.AssertEquals(
            "`"Test string`"", 
            this.debuggerInstance.ToString("`"Test string`""),
            "Passing a quoted string returns the same string"
        )

        this.TestMethod := ""
    }

    TestGetIndent() {
        this.TestMethod := "GetIndent"
        indentStr := "-"

        this.AssertEquals(
            this.debuggerInstance.GetIndent(0, indentStr),
            "",
            "Level 0 returns an empty string"
        )

        this.AssertEquals(
            this.debuggerInstance.GetIndent(10, indentStr), 
            "----------",
            "Level 10 returns the correct string"
        )

        this.TestMethod := ""
    }

    Teardown() {
        ;super.Teardown()
    }
}
