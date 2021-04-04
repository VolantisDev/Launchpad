class LaunchpadBuilder extends AppBase {
    GitTagVersionId {
        get => this.Services.Get("GitTagVersionIdentifier")
        set => this.Services.Set("GitTagVersionIdentifier", value)
    }

    DataSources {
        get => this.Services.Get("DataSourceManager")
        set => this.Services.Set("DataSourceManager", value)
    }

    LaunchpadConfig {
        get => this.Services.Get("LaunchpadConfig")
        set => this.Services.Set("LaunchpadConfig", value)
    }

    FileHasher {
        get => this.Services.Get("FileHasher")
        set => this.Services.Set("FileHasher", value)
    }

    LoadServices(config) {
        super.LoadServices(config)
        this.LaunchpadConfig := LaunchpadConfig.new(this, this.appDir . "\" . this.appName . ".ini")
        this.DataSources := DataSourceManager.new(this.Events)
        this.FileHasher := FileHasher.new(this)
        this.GitTagVersionId := GitTagVersionIdentifier.new(this)
    }

    GetCaches() {
        caches := super.GetCaches()
        return caches
    }

    InitializeApp(config) {
        super.InitializeApp(config)
        this.Auth.SetAuthProvider(LaunchpadApiAuthProvider.new(this, this.State))

        version := this.GitTagVersionId.IdentifyVersion()

        buildInfo := this.GuiManager.Form("BuildSettingsForm", version)

        if (!buildInfo) {
            this.ExitApp()
        }

        if (buildInfo.DeployToApi) {
            this.Auth.Login()
        }

        version := buildInfo.Version

        if (!version) {
            throw AppException.new("Version not provided.")
        }

        this.Version := version
        this.CreateGitTag(version)
        success := LaunchpadBuildOp.new(this, this.GetBuilders(buildInfo)).Run()

        if (!success) {
            throw AppException.new(this.appName . "build failed. Skipping deploy...")
        }

        if (buildInfo.DeployToGitHub || buildInfo.DeployToApi || buildInfo.DeployToChocolatey) {
            releaseInfo := this.GuiManager.Form("ReleaseInfoForm")

            if (!releaseInfo) {
                this.ExitApp()
            }

            success := LaunchpadDeployOp.new(this, this.GetDeployers(buildInfo)).Run()

            if (!success) {
                throw AppException.new(this.appName . " deployment failed. You might need to handle things manually...")
            }
        }

        TrayTip("Finished building " . this.appName . "!", this.appName . " Build", 1)
        this.ExitApp()
    }

    GetBuilders(buildInfo) {
        builders := Map()
        builders["Exe"] := AhkExeBuilder.new(this)

        if (buildInfo.BuildInstaller) {
            builders["Installer"] := NsisInstallerBuilder.new(this)

            if (buildInfo.BuildChocoPkg) {
                builders["Chocolatey Package"] := ChocoPkgBuilder.new(this)
            }
        }
        
        return builders
    }

    GetDeployers(buildInfo) {
        deployers := Map()

        if (buildInfo.DeployToGitHub) {
            deployers["GitHub"] := GitHubBuildDeployer.new(this)
        }

        if (buildInfo.DeployToApi) {
            deployers["Api"] := ApiBuildDeployer.new(this)
        }
        
        if (buildInfo.DeployToChocolatey) {
            deployers["Chocolatey"] := ChocoDeployer.new(this)
        }
        
        return deployers
    }

    CreateGitTag(version) {
        if (!this.GetCmdOutput("git show-ref " . version)) {
            RunWait("git tag " . version, this.appDir)

            response := this.GuiManager.Dialog("DialogBox", "Push git tag?", "Would you like to push the git tag that was just created (" . version . ") to origin?")
        
            if (response == "Yes") {
                RunWait("git push origin " . version, this.appDir)
            }
        }
    }

    InitialSetup(config) {
        ; TODO: Ask initial build setup questions and store them in Launchpad.build.ini
    }

    CheckForUpdates(notify := true) {
        ; TODO: Offer to pull the latest git code if it's outdated, and then restart the script if updates were applied
    }

    ExitApp() {
        this.CleanupBuild()
        super.ExitApp()
    }

    CleanupBuild() {
        if (this.Config.CleanupBuildArtifacts) {
            if (DirExist(this.Config.BuildDir)) {
                DirDelete(this.Config.BuildDir, true)
            }
        }
    }
}
