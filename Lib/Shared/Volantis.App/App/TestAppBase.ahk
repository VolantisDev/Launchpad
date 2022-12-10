class TestAppBase extends AppBase {
    ExitApp() {
        event := AppRunEvent(Events.APP_SHUTDOWN, this)
        this.Service("manager.event").DispatchEvent(event)
        ; Don't actually exit
    }

    RestartApp() {
        event := AppRunEvent(Events.APP_SHUTDOWN, this)
        this.Service("manager.event").DispatchEvent(event)
        ; Don't actually restart
    }
}
