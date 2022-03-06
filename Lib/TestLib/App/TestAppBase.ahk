class TestAppBase extends AppBase {
    ExitApp() {
        event := AppRunEvent(Events.APP_SHUTDOWN, this)
        this.Service("manager.event").DispatchEvent(Events.APP_SHUTDOWN, event)
        ; Don't actually exit
    }

    RestartApp() {
        event := AppRunEvent(Events.APP_SHUTDOWN, this)
        this.Service("manager.event").DispatchEvent(Events.APP_RESTART, event)
        ; Don't actually restart
    }
}
