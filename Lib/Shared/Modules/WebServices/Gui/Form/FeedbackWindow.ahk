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

        webServiceId := "launchpad_api"
        entityMgr := this.container["entity_manager.web_service"]

        results := Map()
        success := false

        if (entityMgr.Has(webServiceId) && entityMgr[webServiceId]["Enabled"]) {
            webService := entityMgr[webServiceId]

            body := Map()
            body["email"] := this.guiObj["Email"].Text
            body["version"] := appVersion
            body["feedback"] := this.guiObj["Feedback"].Text

            results := webService.AdapterRequest(Map("data", body), "feedback_submission", "create", true)
        }

        for key, result in results {
            if (result) {
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
