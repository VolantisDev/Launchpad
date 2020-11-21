class HttpReq {
    url := ""
    timeout := -1
    proxy := ""
    codepage := ""
    charset := ""
    saveAs := ""
    response := ""
    statusCode := 0
    responseData := ""
    requestHeaders := ""
    responseHeaders := ""
    responseBody := ""
    autoRedirect := true
    pos := ""

    __New(url) {
        this.url := url
    }

    Send(method := "GET", data := "") {
        static oHTTP := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	    static oADO := ComObjCreate("adodb.stream")

        if (IsObject(this.url)) {
            ; Clear cookie
            Return oHTTP := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        }

        if (data != "") {
            method := "POST"
        }

        oHTTP.Open(method, this.url, true)

        headers := this.ProcessHeaders(oHTTP)

        if (data != "" and !InStr(headers, "Content-Type:")) {
            oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
        }

        if (this.proxy != "") {
            oHTTP.SetProxy(2, SubStr(A_LoopField, this.pos + 6))
        }

        if (this.codepage != "") {
            oHTTP.Option[2] := SubStr(A_LoopField, this.pos + 9)
        }

        oHTTP.Option[6] := this.autoRedirect

        oHTTP.Send(In_POST__Out_Data)
	    returnCode := oHTTP.WaitForResponse(this.timeout ? this.timeout : -1)

        this.responseBody := oHTTP.ResponseBody
        this.responseHeaders := "HTTP/1.1 " oHTTP.Status() "`n" oHTTP.GetAllResponseHeaders()
        this.responseData := oHTTP.ResponseText
        this.statusCode := oHTTP.Status()

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

    GetStatusCode() {
        return this.statusCode
    }
}
