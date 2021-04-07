class ErrorDialog extends DialogBox {
    displaySubmissionForm := true
    errorObj := ""
    notifierObj := ""
    apiEndpoint := ""

    __New(app, themeObj, windowKey, errorObj, title, text := "", owner := "", parent := "", btns := "*&Continue|&Reload|&Exit") {
        this.errorObj := errorObj
        this.notifierObj := app.Notifications.notifierObj

        if (app.HasProp("DataSources")) {
            this.apiEndpoint := app.DataSources.GetItem("api")
        }
        
        super.__New(app, themeObj, windowKey, title, text, owner, parent, btns)
    }

    Controls() {
        super.Controls()
        this.Add("BasicControl", "vSubmitError", "", false, "CheckBox", "Submit error to Volantis Development")
        this.guiObj.AddText("w" . this.windowSettings["contentWidth"] . " +0x200 +0x100", "Please add as much detail as possible about what you were doing when the error occurred:")
        this.AddEdit("ErrorDetails", "", "r4")
        this.guiObj.AddText("w" . this.windowSettings["contentWidth"] . " +0x200 +0x100", "Optionally, enter your email address if you would like us to reach out to you for further information:")
        this.AddEdit("Email", "", "")
    }

    OnSubmitError(ctl, info) {
        ; TODO: Hide and show the error submission fields automatically based on the checkbox value
    }

    ProcessResult(result, submittedData := "") {
        if (this.guiObj["SubmitError"].Value) {
            this.SendError()
        }

        if (result == "Exit") {
            this.app.ExitApp()
        }

        if (result == "Reload") {
            Reload()
        }

        return super.ProcessResult(result, submittedData)
    }

    SendError() {
        global appVersion

        if (this.apiEndpoint) {
            endpoint := this.apiEndpoint.endpointUrl . "/submit-error"

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
