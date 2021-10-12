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

    Run() {
        success := true

        if (!this.TestAppVersion()) {
            success := false
        }

        if (!this.TestAppConfig()) {
            success := false
        }

        if (!this.TestAppState()) {
            success := false
        }

        if (!this.TestAppServices()) {
            success := false
        }

        if (!this.TestAppLogger()) {
            success := false
        }

        if (!this.TestAppDebugger()) {
            success := false
        }
        
        ; TODO: Add more AppBase tests
        return true
    }

    TestAppVersion() {
        success := true

        if (!this.AssertEquals("Version", this.testAppInstance.Version, this.testVersion)) {
            success := false
        }

        ; TODO: Test changing app version
        return success
    }

    TestAppConfig() {
        return this.AssertEquals("Config", Type(this.testAppInstance.Config), this.appConfigClass)
    }

    TestAppState() {
        return this.AssertEquals("State", Type(this.testAppInstance.State), this.appStateClass)
    }

    TestAppServices() {
        success := true
        ; TODO: Test that Services is a valid service container
        return success
    }

    TestAppLogger() {
        success := true
        ; TODO: Test that a valid logger class exists under Logger
        return success
        
    }

    TestAppDebugger() {
        success := true
        ; TODO: Test that a valid debugger class exists under Debugger
        return success
    }
}
