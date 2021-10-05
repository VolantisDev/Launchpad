class LaunchpadBuilder extends AppBase {
    GetParameterDefinitions(config) {
        parameters := super.GetParameterDefinitions(config)
        parameters["config_path"] := this.appDir . "\Launchpad.build.ini"
        parameters["config.api_endpoint"] := "https://api.launchpad.games/v1"
        parameters["config.api_authentication"] := true
        parameters["config.dist_dir"] := this.appDir . "\Dist"
        parameters["config.build_dir"] := this.appDir . "\Build"
        parameters["config.icon_file"] := this.appDir . "\Resources\Graphics\Launchpad.ico"
        parameters["config.github_username"] := ""
        parameters["config.github_token"] := ""
        parameters["config.github_repo"] := "VolantisDev/Launchpad"
        parameters["config.cleanup_build_artifacts"] := false
        parameters["config.makensis"] := "C:\Program Files (x86)\NSIS\makensis.exe"
        parameters["config.open_build_dir"] := false
        parameters["config.open_dist_dir"] := true
        parameters["config.choco_pkg_name"] := this.GetChocoName()
        return parameters
    }

    GetChocoName() {
        name := StrLower(this.appName)
        StrReplace(name, " ", "-")
        return name
    }

    GetServiceDefinitions(config) {
        services := super.GetServiceDefinitions(config)

        services["LaunchpadConfig"] := Map(
            "class", "LaunchpadConfig",
            "arguments", [AppRef(), this.appDir . "\" . this.appName . ".ini"]
        )

        services["DataSourceManager"] := Map(
            "class", "DataSourceManager",
            "arguments", ServiceRef("EventManager")
        )

        services["FileHasher"] := "FileHasher"

        services["GitTagVersionIdentifier"] := Map(
            "class", "GitTagVersionIdentifier",
            "arguments", AppRef()
        )

        return services
    }

    RunApp(config) {
        super.RunApp(config)
        version := this.Service("GitTagVersionIdentifier").IdentifyVersion()
        buildInfo := this.Service("GuiManager").Form("BuildSettingsForm", version)

        if (!buildInfo) {
            this.ExitApp()
        }

        if (buildInfo.DeployToApi) {
            this.Service("Auth").Login()
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
        if (this.Config["cleanup_build_artifacts"]) {
            if (DirExist(this.Config["build_dir"])) {
                DirDelete(this.Config["build_dir"], true)
            }
        }
    }
}
