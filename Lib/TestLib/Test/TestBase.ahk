class TestBase {
    results := []
    testDir := ""
    testAppInstance := ""
    requiresTestApp := false
    testSuccess := true
    testFinished := false

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
        ; Should be implemented
        return this.testSuccess
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

    AssertTrue(method, value, description := "") {
        condition := (!!value)
        data := Map("Value", value)
        return this.Assertion(method, "Assert True", condition, description, data)
    }

    AssertFalse(method, value, description := "") {
        condition := (!value)
        data := Map("Value", value)
        return this.Assertion(method, "Assert False", condition, description, data)
    }

    AssertEquals(method, value1, value2, description := "") {
        condition := (value1 == value2)
        data := Map("Value 1", value1, "Value 2", value2)
        return this.Assertion(method, "Assert Equals", condition, description, data)
    }

    AssertNotEquals(method, value1, value2, description := "") {
        condition := (value1 != value2)
        data := Map("Value 1", value1, "Value 2", value2)
        return this.Assertion(method, "Assert Not Equals", condition, description, data)
    }

    AssertGreaterThan(method, value1, value2, description := "") {
        condition := (value1 > value2)
        data := Map("Value 1", value1, "Value 2", value2)
        return this.Assertion(method, "Assert Greater Than", condition, description, data)
    }

    AssertLessThan(method, value1, value2, description := "") {
        condition := (value1 < value2)
        data := Map("Value 1", value1, "Value 2", value2)
        return this.Assertion(method, "Assert Less Than", condition, description, data)
    }

    AssertFileExists(method, path, description := "") {
        condition := (!!FileExist(path))
        data := Map("Path", path)
        return this.Assertion(method, "Assert File Exists", condition, description, data)
    }

    AssertFileDoesNotExist(method, path, description := "") {
        condition := (!FileExist(path))
        data := Map("Path", path)
        return this.Assertion(method, "Assert File Does Not Exist", condition, description, data)
    }

    Assertion(method, assertionName, condition, description := "", data := "") {
        success := !!condition
        this.results.Push(Map("success", success, "method", method, "assertion", assertionName, "data", data, "description", description))

        if (!success) {
            this.testSuccess := false
        }

        return success
    }
}
