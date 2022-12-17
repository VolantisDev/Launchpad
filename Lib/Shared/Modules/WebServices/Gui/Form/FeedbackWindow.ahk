class FeedbackWindow extends DialogBox {
    errorObj := ""
    notifierObj := ""

    __New(container, themeObj, config) {
        this.notifierObj := container.Get("notifier").notifierObj
        super.__New(container, themeObj, config)
    }

    GetDefaultConfig(container, config) {
        defaults := super.GetDefaultConfig(container, config)
        defaults["title"] := "Provide Feedback"
        defaults["buttons"] := "*&Send|&Cancel"
        defaults["text"] := "You can use this form to provide any sort of feedback you wish. All feedback will be reviewed by hand, and responded to if you would like."
        return defaults
    }

    Controls() {
        super.Controls()

        this.guiObj.AddText("w" . this.windowSettings["contentWidth"], "Please provide your feedback here:")
        this.AddEdit("Feedback", "", "r6")

        this.guiObj.AddText("w" . this.windowSettings["contentWidth"], "Optionally, enter your email address if you would like us to reach out to you for further information:")
        this.AddEdit("Email", "", "")
    }

    ProcessResult(result, submittedData := "") {
        if (result == "Send") {
            this.SendFeedback()
        }

        return super.ProcessResult(result, submittedData)
    }

    SendFeedback() {
        global appVersion

        filters := "feedback_submission"
        operation := "create"

        if (
            this.container.Has("web_services.adapter_manager")
            && this.container["web_services.adapter_manager"].HasAdapters(filters, operation)
        ) {
            body := Map()
            body["email"] := this.guiObj["Email"].Text
            body["version"] := appVersion
            body["feedback"] := this.guiObj["Feedback"].Text

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

            message := ""

            if (success) {
                message := "Successfully sent feedback"
            } else if (results.Count) {
                message := "Failed to send feedback"
            } else {
                message := "No feedback adapters are enabled"
            }

            this.notifierObj.Notify(
                message, 
                "Feedback Submission", 
                success ? "info" : "error"
            )
        }
    }
}
