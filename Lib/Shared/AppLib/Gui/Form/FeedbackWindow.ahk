class FeedbackWindow extends DialogBox {
    displaySubmissionForm := true
    errorObj := ""
    notifierObj := ""
    apiEndpointUrl := ""

    __New(app, themeObj, windowKey, text := "", owner := "", parent := "", btns := "*&Send|&Cancel") {
        this.notifierObj := app.Service("Notifier").notifierObj
        this.apiEndpointUrl := app.Config.ApiEndpoint
        if (text == "") {
            text := "You can use this form to provide any sort of feedback you wish. All feedback will be reviewed by hand, and responded to if you would like."
        }

        super.__New(app, themeObj, windowKey, "Provide Feedback", text, owner, parent, btns)
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

        if (this.apiEndpointUrl) {
            endpoint := this.apiEndpointUrl . "/submit-feedback"

            body := Map()
            body["email"] := this.guiObj["Email"].Text
            body["version"] := appVersion
            body["feedback"] := this.guiObj["Feedback"].Text

            request := WinHttpReq(endpoint)
            response := request.Send("POST", body)
            success := !!(request.GetStatusCode() == 200)

            notification := success ? "Successfully sent feedback to Volantis Development" : "Failed to send feedback to Volantis Development"
            this.notifierObj.Notify(notification, "Feedback Sent", success ? "info" : "error")
        }
    }
}
