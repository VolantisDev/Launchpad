class TestBase {
    results := []
    testDir := ""
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
        testParameters := Map(
            "config.flush_cache_on_exit", false,
            "config.logging_level", "none",
            "config.module_dirs", [],
        )

        testServices := Map(
            "config.app", Map(
                "class", "RuntimeConfig",
                "arguments", [ContainerRef(), ParameterRef("config_key")]
            )
        )

        return Map(
            "appName", "Test App",
            "developer", "Test Developer",
            "appDir", A_ScriptDir,
            "tmpDir", this.testDir . "\Temp",
            "dataDir", this.testDir . "\Data",
            "version", "1.0.0",
            "parameters", testParameters,
            "services", testServices
        )
    }

    Setup() {
        this.CreateTestDir()
        this.StartTestApp()
    }

    Run() {
        this.RunTestSteps()
        return this.testSuccess
    }

    RunTestSteps() {

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
        return Type(this)
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
