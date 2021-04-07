class AuthModule extends ModuleBase {
    GetDependencies() {
        return []
    }

    GetSubscribers() {
        subscribers := Map()
        subscribers[Events.APP_PRE_LOAD_SERVICES] := [ObjBindMethod(this, "LoadServices")]
        return subscribers
    }

    LoadServices(event, extra, eventName, hwnd) {
        event.App.Services.Set("AuthService", AuthService.new(this.app, "", this.app.State))
    }
}
