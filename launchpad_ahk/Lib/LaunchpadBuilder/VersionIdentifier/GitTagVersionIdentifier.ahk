class GitTagVersionIdentifier extends VersionIdentifierBase {
    repoPath := ""

    __New(app, repoPath := "") {
        this.repoPath := repoPath
        super.__New(app)
    }

    IdentifyVersion(defaultVersion := "") {
        version := defaultVersion

        try {
            latestTag := this.app.GetCmdOutput("git describe --tags --abbrev=0")

            if (latestTag) {
                version := latestTag
            }
        }

        return version
    }
}
