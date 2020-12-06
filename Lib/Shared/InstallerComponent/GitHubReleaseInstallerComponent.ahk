class GitHubReleaseInstallerComponent extends DownloadableInstallerComponent {
    repositoryUrl := ""
    parentStateKey := "LatestRelease"
    version := "latest"
    response := ""

    __New(repositoryName, releaseFile, zipped, destPath, appState, stateKey, cache, parentStateKey := "", overwrite := false, tmpDir := "", onlyCompiled := false) {
        this.repositoryUrl := "https://api.github.com/repos/" . repositoryName . "/releases/" . this.version
        super.__New(releaseFile, zipped, destPath, appState, stateKey, cache, parentStateKey, overwrite, tmpDir, onlyCompiled)
    }

    GetGitHubResponse() {
        if (this.response == "") {
            cacheKey := "GitHubInstallerComponents\" . this.stateKey . ".json"

            if (this.cache.ItemNeedsUpdate(cacheKey)) {
                req := WinHttpReq.new(this.repositoryUrl)
                returnCode := req.Send()
                
                if (returnCode != -1) {
                    return ""
                }

                responseBody := Trim(req.GetResponseData())

                if (responseBody == "") {
                    return ""
                }

                this.cache.WriteItem(cacheKey, responseBody)
            }
            
            this.response := Json.FromString(this.cache.ReadItem(cacheKey))
        }

        if (this.version == "latest") {
            this.version := this.GetVersionFromTagName(this.response["tag_name"])
        }
        
        return this.response
    }

    GetVersionFromTagName(tagName) {
        if (SubStr(tagName, 1, 1) == "v") {
            tagName := SubStr(tagName, 2)
        }

        return tagName
    }

    GetDownloadUrl() {
        response := this.GetGitHubResponse()
        filename := StrReplace(this.downloadUrl, "{{version}}", this.version)
        downloadUrl := ""

        if (Type(response) == "Map" and response.Has("assets")) {
            for (index, component in response["assets"]) {
                if (filename == "" or component["name"] == filename) {
                    downloadUrl := component["browser_download_url"]
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
            ghVersion := this.GetVersionFromTagName(response["tag_name"])

            if (this.VersionIsOutdated(ghVersion, parentVersion)) {
                parentVersion := ghVersion
                this.appState.SetVersion(this.parentStateKey, parentVersion)
            }
        }

        return parentVersion
    }
}
