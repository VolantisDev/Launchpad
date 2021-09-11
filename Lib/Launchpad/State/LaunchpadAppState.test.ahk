class LaunchpadAppStateTest extends TestBase {
    app := ""
    appState := ""
    testDir := A_Temp . "\LaunchpadAppStateTest"

    Setup() {
        if (!DirExist(this.testDir)) {
            DirCreate(this.testDir)
        }

        appConfig := Map()
        this.app := TestApp(appConfig)

        testPath := this.testDir . "\LaunchpadAppStateTest.json"
        this.appState := LaunchpadAppState(this.app, testPath)
    }

    Run() {
        ; Should be implemented
        return true
    }

    Teardown() {
        this.appState := ""
        this.app.ExitApp()
        DirDelete(this.testDir, true)
    }
}
