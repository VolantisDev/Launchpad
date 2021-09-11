class TestBase {
    results := Map()
    testDir := ""
    testAppInstance := ""
    requiresTestApp := false

    __New() {
        this.testDir := A_Temp . "\" . this.GetKey()
    }

    GetTestAppConfig() {
        testServices := Map()

        testAppConfig := Map()
        testAppConfig["appName"] := "Test App"
        testAppConfig["developer"] := "Test Developer"
        testAppConfig["appDir"] := A_ScriptDir
        testAppConfig["tmpDir"] := this.testDir . "\Temp"
        testAppConfig["dataDir"] := this.testDir . "\Data"
        testAppConfig["version"] := "1.0.0"
        testAppConfig["services"] := testServices
        testAppConfig["configClass"] := "AppConfig"
        testAppConfig["stateClass"] := "AppState"

        return testAppCOnfig
    }

    Setup() {
        this.CreateTestDir()
        this.StartTestApp()
    }

    Run() {
        ; Should be implemented
        return true
    }

    Teardown() {
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

    AssertTrue(taskName, value) {
        condition := (!!value)
        data := Map("Value", value)
        return this.Assertion(taskName, "Assert True", condition, data)
    }

    AssertFalse(taskName, value) {
        condition := (!value)
        data := Map("Value", value)
        return this.Assertion(taskName, "Assert False", condition, data)
    }

    AssertEquals(taskName, value1, value2) {
        condition := (value1 == value2)
        data := Map("Value 1", value1, "Value 2", value2)
        return this.Assertion(taskName, "Assert Equals", condition, data)
    }

    AssertNotEquals(taskName, value1, value2) {
        condition := (value1 != value2)
        data := Map("Value 1", value1, "Value 2", value2)
        return this.Assertion(taskName, "Assert Not Equals", condition, data)
    }

    AssertGreaterThan(taskName, value1, value2) {
        condition := (value1 > value2)
        data := Map("Value 1", value1, "Value 2", value2)
        return this.Assertion(taskName, "Assert Greater Than", condition, data)
    }

    AssertLessThan(taskName, value1, value2) {
        condition := (value1 < value2)
        data := Map("Value 1", value1, "Value 2", value2)
        return this.Assertion(taskName, "Assert Less Than", condition, data)
    }

    AssertFileExists(taskName, path) {
        condition := (!!FileExist(path))
        data := Map("Path", path)
        return this.Assertion(taskName, "Assert File Exists", condition, data)
    }

    AssertFileDoesNotExist(taskName, path) {
        condition := (!FileExist(path))
        data := Map("Path", path)
        return this.Assertion(taskName, "Assert File Does Not Exist", condition, data)
    }

    Assertion(taskName, assertionName, condition, data := "") {
        success := !!condition
        this.results[taskName] := Map("success", success, "assertion", assertionName, "data", data)
        return success
    }
}
