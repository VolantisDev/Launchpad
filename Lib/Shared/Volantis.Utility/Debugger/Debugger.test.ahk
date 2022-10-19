class DebuggerTest extends TestBase {
    debuggerInstance := ""

    CreateTestInstances() {
        this.debuggerInstance := Debugger()
    }

    TestSetLogger() {
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
    }

    TestToString() {
        testStrings := [
            "Test string 1",
            "Another test string"
        ]
        
        for testString in testStrings {
            this.AssertEquals(
                "`"" . testString . "`"",
                this.debuggerInstance.ToString(testString),
                "Passing a string wraps it in quotes"
            )

            this.AssertEquals(
                "`"" . testString . "`"",
                this.debuggerInstance.ToString("`"" . testString . "`""),
                "Passing a quoted string returns the same string"
            )
        }
        
        
    }

    TestGetIndent() {
        indents := Map(
            0, "",
            5, "-----",
            10, "----------"
        )

        indentStr := "-"

        for level, matchStr in indents {
            this.AssertEquals(
                this.debuggerInstance.GetIndent(level, indentStr), 
                matchStr,
                "Level " . level . " returns the correct string"
            )
        }
    }
}
