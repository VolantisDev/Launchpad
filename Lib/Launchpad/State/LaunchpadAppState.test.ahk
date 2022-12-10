class LaunchpadAppStateTest extends AppTestBase {
    appState := ""
    stateFile := ""

    Setup() {
        super.Setup()
        ;this.stateFile := this.testDir . "\LaunchpadAppStateTest.json"
        ;this.appState := LaunchpadAppState(this.testAppInstance, this.stateFile)
    }

    Run() {
        ; Should be implemented
        return true
    }

    Teardown() {
        ;FileDelete(this.stateFile)
        ;this.appState := ""
        super.Teardown()
    }
}
