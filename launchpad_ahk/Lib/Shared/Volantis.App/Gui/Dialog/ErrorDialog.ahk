class ErrorDialog extends DialogBox {
    errorObj := ""
    notifierObj := ""
    formShown := false
    formH := 0
    guiH := 0

    __New(container, themeObj, config, errorObj) {
        this.errorObj := errorObj
        this.notifierObj := container.Get("notifier").notifierObj
        this.formShown := config.Has("submitError") ? config["submitError"] : false
        
        super.__New(container, themeObj, config)
    }

    GetDefaultConfig(container, config) {
        defaults := super.GetDefaultConfig(container, config)
        defaults["buttons"] := "*&Continue|&Reload|&Exit",
        defaults["submitError"] := false
        defaults["alwaysOnTop"] := !!(container.GetApp().Config["force_error_window_to_top"])
        return defaults
    }

    Controls() {
        super.Controls()
        ctl := this.Add("BasicControl", "vSubmitError", "", this.config["submitError"], "CheckBox", "Submit error to Volantis Development")
        ctl.ctl.OnEvent("Click", "OnSubmitError")

        ctl := this.guiObj.AddText("w" . this.windowSettings["contentWidth"] . " +0x200 +0x100 vDetailsDesc", "Add as much detail as possible about what you were trying to do:")
        ctl := this.AddEdit("ErrorDetails", "", "r4")
        ctl := this.guiObj.AddText("w" . this.windowSettings["contentWidth"] . " +0x200 +0x100 vEmailDesc", "Enter your email address if you would like to be contacted:")
        ctl := this.AddEdit("Email", "", "")
    }

    GetFormHeight() {
        if (!this.guiH) {
            this.guiObj.GetPos(,,, &guiH)
            this.guiH := guiH
        }

        if (!this.formH) {
            formH := 0

            this.guiObj["DetailsDesc"].GetPos(,,, &ctlH)
            formH += ctlH + this.margin
            this.guiObj["ErrorDetails"].GetPos(,,, &ctlH)
            formH += ctlH + this.margin
            this.guiObj["EmailDesc"].GetPos(,,, &ctlH)
            formH += ctlH + this.margin
            this.guiObj["Email"].GetPos(,,, &ctlH)
            formH += ctlH + this.margin

            this.formH := formH
        }
        
        return this.formH
    }

    ToggleForm(showForm := true, ignoreCurrentState := false) {
        if (this.formShown != showForm || ignoreCurrentState) {
            formH := this.GetFormHeight()

            this.guiObj["DetailsDesc"].Visible := showForm
            this.guiObj["ErrorDetails"].Visible := showForm
            this.guiObj["EmailDesc"].Visible := showForm
            this.guiObj["Email"].Visible := showForm

            if (showForm) {
                this.guiH += formH
            } else {
                this.guiH -= formH
            }

            this.guiObj.Move(,,, this.guiH)
            this.formShown := showForm
        }
    }

    OnShow(windowState := "") {
        super.OnShow(windowState)

        if (!this.formShown) {
            this.ToggleForm(false, true)
        }
    }

    OnSubmitError(ctl, info) {
        this.Submit(false)
        this.ToggleForm(ctl.Value)
    }

    ProcessResult(result, submittedData := "") {
        if (this.guiObj["SubmitError"].Value) {
            this.SendError()
        }

        if (result == "Exit") {
            this.app.ExitApp()
        }

        if (result == "Reload") {
            this.app.RestartApp()
        }

        return super.ProcessResult(result, submittedData)
    }

    SendError() {
        global appVersion

        ; @todo Move the API connection stuff into the LaunchpadApi module
        filters := "error_submission"
        operation := "create"

        if (
            this.container.Has("web_services.adapter_manager")
            && this.container["web_services.adapter_manager"].HasAdapters(filters, operation)
        ) {
            body := Map()
            body["message"] := this.errorObj.Message
            body["what"] := this.errorObj.What
            body["file"] := this.errorObj.File
            body["line"] := this.errorObj.Line
            body["extra"] := this.errorObj.HasProp("Extra") ? this.errorObj.Extra : ""
            body["stack"] := this.errorObj.HasProp("Stack") ? this.errorObj.Stack : ""
            body["email"] := this.guiObj["Email"].Text
            body["version"] := appVersion ? appVersion : ""
            body["details"] := this.guiObj["ErrorDetails"].Text

            results := this.container["web_services.adapter_manager"].AdapterRequest(
                Map("data", body),
                filters,
                operation,
                true
            )

            success := false

            for adapterId, adapterResult in results {
                if (adapterResult) {
                    success := true

                    break
                }
            }

            notification := success ? "Successfully sent error details for further investigation" : "Failed to send error details"
            this.notifierObj.Notify(notification, "Error Submission", success ? "info" : "error")
        }
    }
}
