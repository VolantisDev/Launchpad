class BulkOperationBase {
    app := ""
    results := Map()
    status := Map()
    owner := ""
    parent := ""
    running := false
    completed := false
    successCount := 0
    failedCount := 0
    allowCancel := false
    useProgress := true
    progress := ""
    progressTitle := "Bulk Operation"
    progressText := "Please stand by..."
    progressInitialDetailText := "Initializing..."
    progressRangeEnd := 100
    progressInitialValue := 0
    shouldNotify := false
    successMessage := "Processed {n} item(s) successfully."
    failedMessage := "There were {n} item(s) that failed."

    __New(app, owner := "") {
        InvalidParameterException.CheckTypes("BulkOperationBase", "app", app, "AppBase")
        this.app := app
        this.owner := owner
    }

    Run() {
        if (this.completed) {
            return (this.successCount > 0 && this.failedCount == 0)
        }

        if (this.running) {
            return false
        }

        if (!this.VerifyRequirements()) {
            return false
        }

        if (this.app.Services.Has("Logger")) {
            this.app.Service("Logger").Debug(Type(this) . ": Starting bulk operation...")
        }
        
        this.running := true
        this.ShowProgressWindow()
        this.RunAction()
        this.CloseProgressWindow()
        this.Notify()
        this.running := false
        this.completed := true
        this.LogResults()
        return (this.failedCount == 0)
    }

    LogResults() {
        if (this.app.Services.Has("Logger")) {
            this.app.Service("Logger").Info(Type(this) . " Results: " . this.GetResultMessage())
        }
    }

    VerifyRequirements() {
        return true
    }

    GetResults() {
        return this.results
    }

    GetStatus(key := "") {
        if (key == "") {
            return this.status
        }

        if (!this.status.Has(key)) {
            this.status[key] := BasicOpStatus()
        }

        return this.status[key]
    }

    ShowProgressWindow() {
        if (this.useProgress && this.app.themeReady) {
            if (!IsObject(this.progress)) {
                ownerOrParent := this.owner

                if (this.parent) {
                    ownerOrParent := this.parent
                }

                this.progress := this.app.Service("GuiManager").OpenWindow(Map(
                    "type", "ProgressIndicator",
                    "title", this.progressTitle,
                    "text", this.progressText,
                    "ownerOrParent", ownerOrParent,
                    "child", !!(this.parent),
                    "allowCancel", this.allowCancel,
                    "rangeStop", this.progressRangeEnd,
                    "startingPosition", this.progressInitialValue,
                    "detailText", this.progressInitialDetailText,
                    "unique", true
                ))
            } else {
                this.progress.Show()
            }
        }
    }

    CloseProgressWindow() {
        if (this.useProgress && IsObject(this.progress)) {
            this.progress.Finish()
        }
    }

    Notify() {
        if (this.shouldNotify && this.app.Services.Has("Notifier")) {
            this.app.Service("Notifier").Info(this.GetResultMessage())
        }
    }

    GetResultMessage() {
        message := StrReplace(this.successMessage, "{n}", this.successCount)

        if (this.failedCount > 0) {
            message .= "`n" . StrReplace(this.failedMessage, "{n}", this.failedCount)
        }

        return message
    }

    RunAction() {
        throw MethodNotImplementedException("BulkOperationBase", "RunAction")
    }

    StartItem(key, statusText := "") {
        statusObj := this.GetStatus(key)
        statusObj.Start()

        if (this.useProgress) {
            this.progress.IncrementValue(1, statusText)
        }
    }

    FinishItem(key, success := true, statusText := "", err := "", errCode := "") {
        statusObj := this.GetStatus(key)
        statusObj.Finish(success, err, errCode)

        if (success) {
            this.successCount++
        } else {
            this.failedCount++
        }

        if (this.useProgress && statusText) {
            this.progress.SetDetailText(statusText)
        }
    }
}
