class WinHttpReq extends HttpReqBase {
    static winHttp := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    static adoStream := ComObjCreate("adodb.stream")

    Send(method := "GET", data := "") {
        if (IsObject(this.url)) {
            ; Clear cookie
            return WinHttpReq.winHttp := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        }

        if (data != "") {
            method := "POST"
        }

        WinHttpReq.winHttp.Open(method, this.url, true)

        headers := this.ProcessHeaders(WinHttpReq.winHttp)

        if (data != "" and !InStr(headers, "Content-Type:")) {
            WinHttpReq.winHttp.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
        }

        if (this.proxy != "") {
            WinHttpReq.winHttp.SetProxy(2, SubStr(A_LoopField, this.pos + 6))
        }

        if (this.codepage != "") {
            WinHttpReq.winHttp.Option[2] := SubStr(A_LoopField, this.pos + 9)
        }

        WinHttpReq.winHttp.Option[6] := this.autoRedirect

        WinHttpReq.winHttp.Send(data)
	    returnCode := WinHttpReq.winHttp.WaitForResponse(this.timeout ? this.timeout : -1)

        this.responseBody := WinHttpReq.winHttp.ResponseBody
        this.responseHeaders := "HTTP/1.1 " WinHttpReq.winHttp.Status() "`n" WinHttpReq.winHttp.GetAllResponseHeaders()
        this.responseData := WinHttpReq.winHttp.ResponseText
        this.statusCode := WinHttpReq.winHttp.Status()

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
