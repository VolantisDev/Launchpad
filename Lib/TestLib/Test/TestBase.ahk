class TestBase {
    results := []
    testDir := ""
    testAppVersion := "1.23.45"
    testAppInstance := ""
    requiresTestApp := false
    testSuccess := true
    testFinished := false
    testMethodVal := ""

    TestMethod {
        get => this.testMethodVal
        set => this.testMethodVal := value
    }

    __New() {
        this.testDir := A_Temp . "\" . this.GetKey()
    }

    GetTestAppConfig() {
        config := Map(
            "appName", "Test App",
            "developer", "Test Developer",
            "appDir", A_ScriptDir,
            "tmpDir", this.testDir . "\Temp",
            "dataDir", this.testDir . "\Data",
            "version", this.testAppVersion,
            "parameters", Map(
                "config.flush_cache_on_exit", false,
                "config.logging_level", "none",
                "config.module_dirs", [],
            ),
            "services", Map(
                "config.app", Map(
                    "class", "RuntimeConfig",
                    "arguments", [ContainerRef(), ParameterRef("config_key")]
                )
            )
        )

        return config
    }

    Setup() {
        this.CreateTestDir()
        this.StartTestApp()
        this.CreateTestInstances()
    }

    CreateTestInstances() {
        
    }

    Run() {
        this.RunTestSteps()
        return this.testSuccess
    }

    GetTestSteps() {
        testSteps := []

        for propName in this.Base.OwnProps() {
            if (InStr(propName, "Test", true) == 1) {
                propDesc := this.Base.GetOwnPropDesc(propName)

                if propDesc.HasProp('Call') {
                    testSteps.Push(propName)
                }
            }
		}

        return testSteps
    }

    RunTestSteps() {
        testSteps := this.GetTestSteps()

        if (testSteps.HasBase(Array.Prototype)) {
            for index, params in testSteps {
                methodName := ""

                if (params.HasBase(Array.Prototype)) {
                    methodName := params.RemoveAt(1)
                } else {
                    methodName := params
                    params := ""
                }
                
                if (methodName) {
                    this.RunTestStep(methodName, params)
                }
            }
        }
    }

    RunTestStep(methodName, params := "") {
        testMethod := methodName
        
        if (InStr(methodName, "Test") == 1) {
            testMethod := SubStr(methodName, 5)
        }

        this.TestMethod := testMethod

        if (methodName && this.HasProp(methodName)) {
            methodToCall := this.%methodName%

            if (!params) {
                params := []
            }

            params.InsertAt(1, this)
            methodToCall(params*)
        }

        this.TestMethod := ""
    }

    Teardown() {
        this.testFinished := true
        this.StopTestApp()
        this.DeleteTestDir()
    }

    CreateTestDir() {
        if (this.testDir) {
            if (DirExist(this.testDir)) {
                DirDelete(this.testDir, true)
            }

            DirCreate(this.testDir)
        }
    }

    DeleteTestDir() {
        if (this.testDir && DirExist(this.testDir)) {
            DirDelete(this.testDir, true)
        }
    }

    StartTestApp() {
        if (this.requiresTestApp) {
            this.testAppInstance := TestApp(this.GetTestAppConfig())
        }
    }

    StopTestApp() {
        if (this.requiresTestApp && this.testAppInstance) {
            this.testAppInstance.ExitApp()
        }
    }

    GetKey() {
        return SubStr(Type(this), 1, -4)
    }

    GetResults() {
        return this.results
    }

    GetSuccessStatus() {
        return this.testFinished && this.testSuccess
    }

    AssertTrue(value, description := "") {
        return this.Assertion(
            "Assert True", 
            (!!value), 
            description, 
            Map("Value", value)
        )
    }

    AssertFalse(value, description := "") {
        return this.Assertion(
            "Assert False", 
            (!value), 
            description, 
            Map("Value", value)
        )
    }

    AssertEquals(value1, value2, description := "") {
        return this.Assertion(
            "Assert Equals", 
            (value1 == value2), 
            description, 
            Map(
                "Value 1", value1, 
                "Value 2", value2
            )
        )
    }

    AssertEmpty(value, description := "") {
        return this.Assertion(
            "Assert Empty",
            (value == ""),
            description,
            Map("Value", value)
        )
    }

    AssertNotEquals(value1, value2, description := "") {
        return this.Assertion(
            "Assert Not Equals", 
            (value1 != value2), 
            description, 
            Map(
                "Value 1", value1, 
                "Value 2", value2
            )
        )
    }

    AssertGreaterThan(value1, value2, description := "") {
        return this.Assertion(
            "Assert Greater Than", 
            (value1 > value2), 
            description, 
            Map(
                "Value 1", value1, 
                "Value 2", value2
            )
        )
    }

    AssertLessThan(value1, value2, description := "") {
        return this.Assertion(
            "Assert Less Than", 
            (value1 < value2), 
            description, 
            Map(
                "Value 1", value1, 
                "Value 2", value2
            )
        )
    }

    AssertFileExists(path, description := "") {
        return this.Assertion(
            "Assert File Exists", 
            (!!FileExist(path)), 
            description, 
            Map("Path", path)
        )
    }

    AssertFileDoesNotExist(path, description := "") {
        return this.Assertion(
            "Assert File Does Not Exist", 
            (!FileExist(path)), 
            description, 
            Map("Path", path)
        )
    }

    Assertion(assertionName, condition, description := "", data := "") {
        success := !!condition

        this.results.Push(Map(
            "success", success, 
            "method", this.TestMethod, 
            "assertion", assertionName, 
            "data", data, 
            "description", description
        ))

        if (!success) {
            this.testSuccess := false
        }

        return success
    }
}
