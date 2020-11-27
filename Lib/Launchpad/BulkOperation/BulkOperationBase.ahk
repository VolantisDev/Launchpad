class BulkOperationBase {
    app := ""
    results := Map()
    status := Map()
    owner := "MainWindow"
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
    notify := false
    successMessage := "Processed {n} item(s) successfully."
    failedMessage := "There were {n} item(s) that failed."

    __New(app, owner := "") {
        this.app := app

        if (!IsObject(owner)) {
            if (owner == "") {
                owner := this.owner
            }

            if (!IsObject(owner)) {
                owner := app.Windows.GetGuiObj(owner)
            }
        }

        this.owner := owner
    }

    Run() {
        if (this.completed) {
            return this.results
        }

        if (this.running) {
            return false
        }

        if (!this.VerifyRequirements()) {
            return false
        }

        this.running := true
        this.ShowProgressWindow()
        this.RunAction()
        this.CloseProgressWindow()
        this.Notify()
        this.running := false
        this.completed := true
        return (this.successCount > 0 and this.failedCount == 0)
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
            this.status[key] := BasicOpStatus.new()
        }

        return this.status[key]
    }

    ShowProgressWindow() {
        if (this.useProgress) {
            if (!IsObject(this.progress)) {
                this.progress := this.app.Windows.ProgressIndicator(this.progressTitle, this.progressText, this.owner, this.allowCancel, this.progressRangeEnd, this.progressInitialValue, this.progressInitialDetailText)
            } else {
                this.progress.Show()
            }
        }
    }

    CloseProgressWindow() {
        if (this.useProgress and IsObject(this.progress)) {
            this.progress.Finish()
        }
    }

    Notify() {
        if (this.notify) {
            message := StrReplace(this.successMessage, "{n}", this.successCount)

            if (this.failedCount > 0) {
                message .= "`n" . StrReplace(this.failedMessage, "{n}", this.failedCount)
            }

            this.app.Notifications.Info(message)
        }
    }

    RunAction() {

    }

    StartItem(key, statusText := "") {
        statusObj := this.GetStatus(key)
        statusObj.Start()

        if (this.useProgress and statusText) {
            this.progress.IncrementValue(1, statusText)
        }
    }

    FinishItem(key, success := true, statusText := "", err := "", errCode := "") {
        statusObj := this.GetStatus(key)
        statusObj.Finish(success, err, errCode)

        if (this.useProgress and statusText) {
            this.progress.SetDetailText(statusText)
        }
    }
}
