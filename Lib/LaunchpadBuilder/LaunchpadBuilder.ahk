class LaunchpadBuilder extends AppBase {
    GitTagVersionId {
        get => this.Services.Get("GitTagVersionIdentifier")
        set => this.Services.Set("GitTagVersionIdentifier", value)
    }

    DialogVersionId {
        get => this.Services.Get("DialogVersionIdentifier")
        set => this.Services.Set("DialogVersionIdentifier", value)
    }

    DataSources {
        get => this.Services.Get("DataSourceManager")
        set => this.Services.Set("DataSourceManager", value)
    }

    LaunchpadConfig {
        get => this.Services.Get("LaunchpadConfig")
        set => this.Services.Set("LaunchpadConfig", value)
    }

    LoadServices(config) {
        super.LoadServices(config)
        this.LaunchpadConfig := LaunchpadConfig.new(this, this.appDir . "\" . this.appName . ".ini")
        this.DataSources := DataSourceManager.new(this.Events)
        this.GitTagVersionId := GitTagVersionIdentifier.new(this)
        this.DialogVersionId := DialogVersionIdentifier.new(this)
    }

    GetCaches() {
        caches := super.GetCaches()
        return caches
    }

    InitializeApp(config) {
        super.InitializeApp(config)
        this.Auth.SetAuthProvider(LaunchpadApiAuthProvider.new(this, this.State))

        if (this.Config.DeployRelease) {
            this.Auth.Login()
        }

        version := this.GitTagVersionId.IdentifyVersion()
        version := this.DialogVersionId.IdentifyVersion(version)
        
        if (!version) {
            this.ExitApp()
        }

        this.Version := version
        this.CreateGitTag(version)
        success := LaunchpadBuildOp.new(this, this.GetBuilders()).Run()

        if (!success) {
            throw AppException.new(this.appName . "build failed. Skipping deploy...")
        }

        if (this.Config.DeployRelease) {
            releaseInfo := this.GuiManager.Form("ReleaseInfoForm")

            if (!releaseInfo) {
                this.ExitApp()
            }

            success := LaunchpadDeployOp.new(this, this.GetDeployers()).Run()

            if (!success) {
                throw AppException.new(this.appName . " deployment failed. You might need to handle things manually...")
            }
        }

        TrayTip("Finished building " . this.appName . "!", this.appName . " Build", 1)
    }

    GetBuilders() {
        builders := Map()
        builders["Exe"] := AhkExeBuilder.new(this)
        builders["Installer"] := NsisInstallerBuilder.new(this)
        return builders
    }

    GetDeployers() {
        deployers := Map()
        deployers["GitHub"] := GitHubBuildDeployer.new(this)
        deployers["Api"] := ApiBuildDeployer.new(this)
        return deployers
    }

    CreateGitTag(version) {
        if (!this.GetCmdOutput("git show-ref " . version)) {
            RunWait("git tag " . version, this.appDir)

            response := this.GuiManager.Dialog("DialogBox", "Push git tag?" "Would you like to push the git tag that was just created (" . version . ") to origin?")
        
            if (response == "Yes") {
                RunWait("git push origin " . version, this.appDir)
            }
        }
    }

    InitialSetup(config) {
        ; TODO: Ask initial build setup questions and store them in Launchpad.build.ini
    }

    CheckForUpdates() {
        ; TODO: Offer to pull the latest git code if it's outdated, and then restart the script if updates were applied
    }

    ExitApp() {
        this.CleanupBuild()
        super.ExitApp()
    }

    CleanupBuild() {
        if (this.Config.CleanupBuildArtifacts) {
            DirDelete(this.Config.BuildDir . "\Lib", true)
            DirDelete(this.Config.BuildDir . "\Resources", true)
            DirDelete(this.Config.BuildDir . "\Vendor", true)
            FileDelete(this.Config.BuildDir . "\" . this.appName . ".exe")
        }
    }
}
