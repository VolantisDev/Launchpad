class LaunchpadBuilderConfig extends AppConfig {
    DistDir {
        get => this.app.appDir . "\Dist"
    }

    BuildDir {
        get => this.app.appDir . "\Build"
    }

    IconFile {
        get => this.GetIniValue("IconFile") || this.app.appDir . "\Resources\Graphics\Launchpad.ico"
        set => this.SetIniValue("IconFile", value)
    }

    GitHubUsername {
        get => this.GetIniValue("GitHubUsername")
        set => this.SetIniValue("GitHubUsername", value)
    }

    GitHubToken {
        get => this.GetIniValue("GitHubToken")
        set => this.SetIniValue("GitHubToken", value)
    }

    GitHubRepo {
        get => this.GetIniValue("GitHubRepo") || "VolantisDev/Launchpad"
        set => this.SetIniValue("GitHubRepo", value)
    }

    ApiEndpoint {
        get => this.GetIniValue("ApiEndpoint") || "https://api.launchpad.games/v1"
        set => this.SetIniValue("ApiEndpoint", value)
    }

    ApiAuthentication {
        get => true
    }

    CleanupBuildArtifacts {
        get => this.GetBooleanValue("CleanupBuildArtifacts", false)
        set => this.SetBooleanValue("CleanupBuildArtifacts", value)
    }

    MakeNsis {
        get => this.GetIniValue("MakeNsis") || "C:\Program Files (x86)\NSIS\makensis.exe"
        set => this.SetIniValue("MakeNsis", value)
    }

    OpenBuildDir {
        get => this.GetBooleanValue("OpenBuildDir", false)
        set => this.SetBooleanValue("OpenBuildDir", value)
    }

    OpenDistDir {
        get => this.GetBooleanValue("OpenDistDir", true)
        set => this.SetBooleanValue("OpenDistDir", value)
    }

    ChocoPkgName {
        get => this.GetIniValue("ChocoPkgName") || this.GenerateChocoPkgName()
        set => this.SetIniValue("ChocoPkgName", value)
    }

    GenerateChocoPkgName() {
        name := StrLower(this.app.appName)
        StrReplace(name, " ", "-")
        return name
    }

    OpenDestinationDir() {
        Run(this.DestinationDir)
    }

    ChangeDestinationDir(existingDir := "") {
        if (existingDir == "") {
            existingDir := this.DestinationDir
        }

        destinationDir := this.SelectDestinationDir(existingDir)

        if (destinationDir != "") {
            this.DestinationDir := destinationDir
        }

        return destinationDir
    }

    SelectDestinationDir(existingDir) {
        if (existingDir != "") {
            existingDir := "*" . existingDir
        }

        return DirSelect(existingDir, 3, "Create or select the folder to build " . this.app.appName . " within")
    }
}
