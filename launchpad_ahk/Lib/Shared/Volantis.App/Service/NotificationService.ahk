class NotificationService extends AppServiceBase {
    notifierObj := ""

    __New(app, notifierObj) {
        InvalidParameterException.CheckTypes("NotificationService", "notifierObj", notifierObj, "NotifierBase")
        this.notifierObj := notifierObj
        super.__New(app)
    }

    SetNotifier(notifierObj) {
        this.notifierObj := notifierObj
    }

    Notify(message, title := "", level := "Info") {
        return this.notifierObj.Notify(message, title, level)
    }

    Debug(message, title := "") {
        return this.Notify(message, title, "Debug")
    }

    Info(message, title := "") {
        return this.Notify(message, title, "Info")
    }

    Warning(message, title := "") {
        return this.Notify(message, title, "Warning")
    }

    Error(message, title := "") {
        return this.Notify(message, title, "Error")
    }

    GetNotifier() {
        return this.notifierObj
    }
}
