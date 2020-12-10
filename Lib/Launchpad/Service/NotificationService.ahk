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

    Notify(message, title := "", level := "info") {
        return this.notifierObj.Notify(message, title, level)
    }

    Debug(message, title := "") {
        return this.Notify(message, title, "debug")
    }

    Info(message, title := "") {
        return this.Notify(message, title, "info")
    }

    Warning(message, title := "") {
        return this.Notify(message, title, "warning")
    }

    Error(message, title := "") {
        return this.Notify(message, title, "error")
    }
}
