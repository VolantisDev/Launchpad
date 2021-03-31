class GitHubBuildDeployer extends BuildDeployerBase {
    Deploy(deployInfo) {
        ; TODO: Fix GitHub API request to post new release
        request := this.GetHttpReq("https://api.github.com/repos/" . this.app.Config.GitHubRepo . "/releases")
        response := request.Send("POST", this.GetPostData(deployInfo))
        success := !!(response == -1 && request.GetStatusCode() == 200)
        responseData := request.GetResponseData()

        if (!success || !responseData) {
            throw AppException.new("Failed to post release to GitHub")
        }

        json := JsonData.new()
        responseObj := json.FromString(responseData)

        if (!responseObj.Has("upload_url") || !responseObj["upload_url"]) {
            throw AppException.new("Could not determine release file upload URL")
        }

        success := this.UploadInstaller(deployInfo, responseObj["upload_url"])

        if (!success) {
            throw AppException.new("Failed to upload installer file")
        }

        return success
    }

    GetHttpReq(url) {
        request := WinHttpReq.new(url)
        request.requestHeaders["Authorization"] := "Basic " . this.Base64Encode(this.app.Config.GitHubUsername . ":" . this.app.Config.GitHubToken)
    }

    UploadInstaller(deployInfo, uploadUrl) {
        installer := this.app.Config.DistDir . "\" . this.app.appName . "-" . this.app.Version . ".exe"
        success := false

        if (FileExist(installer)) {
            request := this.GetHttpReq(uploadUrl)
            request.requestHeaders["Content-Length"] := FileGetSize(installer)
            request.requestHeaders["Content-Type"] := "application/vnd.microsoft.portable-executable"
            response := request.Send("POST", installer, true)
            success := !!(response == -1 && request.GetStatusCode() == 200)
        }

        return success
    }

    GetPostData(deployInfo) {
        postData := Map()
        postData["tag_name"] := this.app.Version
        postData["name"] := deployInfo.ReleaseTitle
        postData["body"] := deployInfo.ReleaseNotes
        postData["draft"] := deployInfo.CreateAsDraft
        postData["prerelease"] := deployInfo.MarkAsPrerelease
        return postData
    }

    Base64Encode(ByRef data, len := -1, ByRef out := "") {
        bytesPerChar := 2

        if (Round(len) <= 0) {
            len := StrLen(data) * 2
        }

        result := ""
        dll := "Crypt32\CryptBinaryToString"

        sizeBuf := BufferAlloc(8, 0)

        ; if DllCall(dll, "Ptr", StrPtr(data), "UInt", len, "UInt", 0x00000001, "Ptr", 0, "UIntP", sizeBuf.Ptr) {
        ;     size := NumGet(sizeBuf, 0, "UInt")
        ;     out := BufferAlloc(size *= bytesPerChar, 0)

        ; 	if DllCall(dll, "Ptr", StrPtr(data), "UInt", len, "UInt", 0x00000001, "Ptr", out, "UIntP", sizeBuf.Ptr) {
        ;         size := NumGet(sizeBuf, 0, "UInt")
        ;         result := size * BytesPerChar
        ;         MsgBox(result)
        ;     }
        ; }

        return result
    }
}
