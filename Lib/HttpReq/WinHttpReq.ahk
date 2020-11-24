class WinHttpReq extends HttpReqBase {
    static winHttp := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    static adoStream := ComObjCreate("adodb.stream")

    Send(method := "GET", data := "") {
        if (IsObject(this.url)) {
            ; Clear cookie
            return this.oHTTP := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        }

        if (data != "") {
            method := "POST"
        }

        this.oHTTP.Open(method, this.url, true)

        headers := this.ProcessHeaders(this.oHTTP)

        if (data != "" and !InStr(headers, "Content-Type:")) {
            this.oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
        }

        if (this.proxy != "") {
            this.oHTTP.SetProxy(2, SubStr(A_LoopField, this.pos + 6))
        }

        if (this.codepage != "") {
            this.oHTTP.Option[2] := SubStr(A_LoopField, this.pos + 9)
        }

        this.oHTTP.Option[6] := this.autoRedirect

        this.oHTTP.Send(data)
	    returnCode := this.oHTTP.WaitForResponse(this.timeout ? this.timeout : -1)

        this.responseBody := this.oHTTP.ResponseBody
        this.responseHeaders := "HTTP/1.1 " this.oHTTP.Status() "`n" this.oHTTP.GetAllResponseHeaders()
        this.responseData := this.oHTTP.ResponseText
        this.statusCode := this.oHTTP.Status()

        this.returnCode := returnCode
        return returnCode
    }

    ProcessHeaders(oHTTP) {
        headers := ""

        if (this.requestHeaders) {
            headers := Trim(this.requestHeaders, " `t`r`n")

            Loop Parse headers, "`n", "`r"
            {
                this.pos := InStr(A_LoopField, ":")

                If (!this.pos) {
                    Continue
                }

                Header_Name  := SubStr(A_LoopField, 1, this.pos - 1)
                Header_Value := SubStr(A_LoopField, this.pos + 1)

                If (Trim(Header_Value) != "") {
                    oHTTP.SetRequestHeader(Header_Name, Header_Value)
                }  
            }
        }

        return headers
    }
}
