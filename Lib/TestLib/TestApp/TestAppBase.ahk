class TestAppBase extends AppBase {
    developer := "Test Developer"
    versionStr := "1.0.0"
    appName := "Test App"

    ExitApp() {
        event := AppRunEvent(Events.APP_SHUTDOWN, this)
        this.Service("EventManager").DispatchEvent(Events.APP_SHUTDOWN, event)
        ; Don't actually exit
    }

    RestartApp() {
        event := AppRunEvent(Events.APP_SHUTDOWN, this)
        this.Service("EventManager").DispatchEvent(Events.APP_RESTART, event)
        ; Don't actually restart
    }
}
