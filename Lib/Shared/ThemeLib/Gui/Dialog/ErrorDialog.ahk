class ErrorDialog extends DialogBox {
    displaySubmissionForm := true
    errorObj := ""
    notifierObj := ""
    apiEndpointUrl := ""

    __New(app, themeObj, windowKey, errorObj, notifierObj, apiEndpointUrl, title, text := "", owner := "", parent := "", btns := "*&Continue|&Exit Launchpad") {
        this.errorObj := errorObj
        this.notifierObj := notifierObj
        this.apiEndpointUrl := apiEndpointUrl
        super.__New(app, themeObj, windowKey, title, text, owner, parent, btns)
    }

    Controls() {
        super.Controls()

        this.AddCheckBox("Submit error to Volantis Development", "SubmitError", false, false)

        this.guiObj.AddText("w" . this.windowSettings["contentWidth"], "Please add as much detail as possible about what you were doing when the error occurred:")
        this.AddEdit("ErrorDetails", "", "r4")

        this.guiObj.AddText("w" . this.windowSettings["contentWidth"], "Optionally, enter your email address if you would like us to reach out to you for further information:")
        this.AddEdit("Email", "", "")
    }

    OnSubmitError(ctl, info) {
        ; @todo Show or hide the controls below, move the buttons, and resize the window
        ; @todo perhaps break out a separate ResizeDialog function which automatically moves the buttons
    }

    ProcessResult(result) {
        if (this.guiObj["SubmitError"].Value) {
            this.SendError()
        }

        return super.ProcessResult(result)
    }

    SendError() {
        global appVersion

        if (this.apiEndpointUrl) {
            endpoint := this.apiEndpointUrl . "/submit-error"

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

            request := WinHttpReq.new(endpoint)
            response := request.Send("POST", body)
            success := !!(response == -1 && request.GetStatusCode() == 200)

            notification := success ? "Successfully sent error to Volantis Development" : "Failed to send error to Volantis Development"
            this.notifierObj.Notify(notification, "Error Sent", success ? "info" : "error")
        }
    }
}
