class AppBaseTest extends TestBase {
    requiresTestApp := true
    testAppVersion := "76.9.12"
    testAppConfigClass := "RuntimeConfig"
    testAppStateClass := "AppState"

    TestVersion() {
        this.AssertEquals(
            this.testAppInstance.Version, 
            this.testAppVersion, 
            "App version is " . this.testAppVersion
        )
    }

    TestConfig() {
        this.AssertEquals(
            Type(this.testAppInstance.Config), 
            this.testAppConfigClass, 
            "App config class is " . this.testAppConfigClass
        )
    }

    TestState() {
        this.AssertEquals(
            Type(this.testAppInstance.State), 
            this.testAppStateClass, 
            "App state class is " . this.testAppStateClass
        )
    }
}
