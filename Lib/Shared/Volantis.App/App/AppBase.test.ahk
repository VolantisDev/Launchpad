class AppBaseTest extends TestBase {
    testVersion := "76.9.12"
    appConfigClass := "AppConfig"
    appStateClass := "AppState"
    requiresTestApp := true

    GetTestAppConfig() {
        testAppConfig := super.GetTestAppConfig()
        testAppConfig["version"] := this.testVersion
        testAppConfig["configClass"] := this.appConfigClass
        testAppConfig["stateClass"] := this.appStateClass
        return testAppConfig
    }

    RunTestSteps() {
        this.TestAppVersion()
        this.TestAppConfig()
        this.TestAppState()
        ; @todo Add more AppBase tests
    }

    TestAppVersion() {
        this.TestMethod := "Version"
        this.AssertEquals(this.testAppInstance.Version, this.testVersion)
        ; @todo Test changing app version
        this.TestMethod := ""
    }

    TestAppConfig() {
        this.TestMethod := "Config"
        this.AssertEquals(Type(this.testAppInstance.Config), this.appConfigClass)
        this.TestMethod := ""
    }

    TestAppState() {
        this.TestMethod := "State"
        this.AssertEquals(Type(this.testAppInstance.State), this.appStateClass)
        this.TestMethod := ""
    }
}
