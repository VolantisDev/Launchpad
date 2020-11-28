class GitHubReleaseInstallerAsset extends DownloadableInstallerAsset {
    repositoryUrl := ""
    parentStateKey := "LatestRelease"
    version := "latest"

    __New(repositoryName, releaseFile, zipped, destPath, appState, stateKey, parentStateKey := "", overwrite := false, tmpDir := "") {
        this.repositoryUrl := "https://api.github.com/repos/" . repositoryName . "/releases/" . this.version
        super.__New(releaseFile, zipped, destPath, appState, stateKey, parentStateKey, overwrite, tmpDir)
    }

    GetGitHubResponse() {
        static response := ""

        if (response == "") {
            req := WinHttpReq.new(this.repositoryUrl)
            returnCode := req.Send()
            
            if (returnCode != 0) {
                return false
            }

            responseBody := req.GetResponseBody()

            if (responseBody == "") {
                return false
            }
            
            response := Jxon_Load(responseBody)
        }
        
        return response
    }

    GetDownloadUrl() {
        response := this.GetGitHubResponse()
        filename := this.downloadUrl
        downloadUrl := ""

        if (response.Has("assets")) {
            for (index, asset in response["assets"]) {
                if (filename == "" or asset["name"] == filename) {
                    downloadUrl := asset["url"]
                    break
                }
            }
        }

        return downloadUrl
    }

    GetParentVersion() {
        parentVersion := super.GetParentVersion()
        response := this.GetGitHubResponse()

        if (response.Has("tag_name")) {
            ghVersion := response["tag_name"]

            if (SubStr(ghVersion, 1, 1) == "v") {
                ghVersion := SubStr(ghVersion, 2)
            }

            if (ghVersion >= parentVersion) {
                parentVersion := ghVersion
                this.appState.SetVersion(this.parentStateKey, parentVersion)
            }
        }

        return parentVersion
    }
}
