class LaunchpadBuilder extends AppBase {
    LoadServices(config) {
        super.LoadServices(config)
        this.Services.Set("LaunchpadConfig", LaunchpadConfig(this, this.appDir . "\" . this.appName . ".ini"))
        this.Services.Set("DataSourceManager", DataSourceManager(this.Service("EventManager")))
        this.Services.Set("FileHasher", FileHasher())
        this.Services.Set("GitTagVersionIdentifier", GitTagVersionIdentifier(this))
    }

    GetCaches() {
        caches := super.GetCaches()
        return caches
    }

    InitializeApp(config) {
        super.InitializeApp(config)
        this.Service("AuthService").SetAuthProvider(LaunchpadApiAuthProvider(this, this.State))
    }

    RunApp(config) {
        super.RunApp(config)
        version := this.Service("GitTagVersionIdentifier").IdentifyVersion()
        buildInfo := this.Service("GuiManager").Form("BuildSettingsForm", version)

        if (!buildInfo) {
            this.ExitApp()
        }

        if (buildInfo.DeployToApi) {
            this.Service("AuthService").Login()
        }

        version := buildInfo.Version

        if (!version) {
            throw AppException("Version not provided.")
        }

        this.Version := version
        this.CreateGitTag(version)

        success := LaunchpadBuildOp(this, this.GetBuilders(buildInfo)).Run()

        if (!success) {
            throw AppException(this.appName . "build failed. Skipping deploy...")
        }

        if (buildInfo.DeployToGitHub || buildInfo.DeployToApi || buildInfo.DeployToChocolatey) {
            releaseInfo := this.Service("GuiManager").Form("ReleaseInfoForm")

            if (!releaseInfo) {
                this.ExitApp()
            }

            success := LaunchpadDeployOp(this, this.GetDeployers(buildInfo)).Run()

            if (!success) {
                throw AppException(this.appName . " deployment failed. You might need to handle things manually...")
            }
        }

        TrayTip("Finished building " . this.appName . "!", this.appName . " Build", 1)
        this.ExitApp()
    }

    GetBuilders(buildInfo) {
        builders := []
        
        if (buildInfo.BuildLaunchpadOverlay) {
            builders.Push(LaunchpadOverlayBuilder(this))
        }

        if (buildInfo.BuildAhkBins) {
            builders.Push(AhkBinsBuilder(this))
        }
        
        if (buildInfo.BuildLaunchpad) {
            builders.Push(AhkExeBuilder(this))

            if (buildInfo.BuildInstaller) {
                builders.Push(NsisInstallerBuilder(this))

                if (buildInfo.BuildChocoPkg) {
                    builders.Push(ChocoPkgBuilder(this))
                }
            }
        }
        
        return builders
    }

    GetDeployers(buildInfo) {
        deployers := Map()

        if (buildInfo.DeployToGitHub) {
            deployers["GitHub"] := GitHubBuildDeployer(this)
        }

        if (buildInfo.DeployToApi) {
            deployers["Api"] := ApiBuildDeployer(this)
        }
        
        if (buildInfo.DeployToChocolatey) {
            deployers["Chocolatey"] := ChocoDeployer(this)
        }
        
        return deployers
    }

    CreateGitTag(version) {
        if (!this.GetCmdOutput("git show-ref " . version)) {
            RunWait("git tag " . version, this.appDir)

            response := this.Service("GuiManager").Dialog("DialogBox", "Push git tag?", "Would you like to push the git tag that was just created (" . version . ") to origin?")
        
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
