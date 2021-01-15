class DetectedGame {
    key := ""
    platform := ""
    detectedKey := ""
    launcherType := ""
    gameType := ""
    installDir := ""
    exeName := ""
    launcherSpecificId := ""
    possibleExeNames := []

    __New(key, platform, launcherType, gameType := "Default", installDir := "", exeName := "", launcherSpecificId := "", possibleExeNames := "") {
        this.key := key
        this.platform := platform
        this.detectedKey := key
        this.launcherType := launcherType
        this.gameType := gameType
        this.installDir := installDir
        this.exeName := exeName
        this.launcherSpecificId := launcherSpecificId

        if (possibleExeNames) {
            if (Type(possibleExeNames) == "String") {
                possibleExeNames := [possibleExeNames]
            }

            this.possibleExeNames := possibleExeNames
        }
    }

    HasChanges(launcher) {
        hasChanges := false
            
        if (this.launcherType != launcher.ManagedLauncher.EntityType || this.gameType != launcher.ManagedLauncher.ManagedGame.EntityType || this.installDir != launcher.ManagedLauncher.ManagedGame.InstallDir || this.exeName != launcher.ManagedLauncher.ManagedGame.Exe || this.launcherSpecificId != launcher.ManagedLauncher.ManagedGame.LauncherSpecificId) {
            hasChanges := true
        }

        return hasChanges
    }

    UpdateLauncher(launcher) {
        modified := false
                
        if (this.launcherType) {
            launcher.LauncherType := this.LauncherType
            modified := true
        }

        if (this.gameType) {
            launcher.GameType := this.gameType
            modified := true
        }

        if (this.installDir) {
            launcher.ManagedLauncher.ManagedGame.InstallDir := this.installDir
            modified := true
        }

        if (this.exeName) {
            launcher.ManagedLauncher.ManagedGame.Exe := this.exeName
            modified := true
        }

        if (modified) {
            launcher.SaveModifiedData()
        }
    }

    CreateLauncher(launcherManager) {
        config := Map("LauncherType", this.launcherType, "GameType", this.gameType)

        if (this.installDir) {
            config["GameInstallDir"] := this.installDir
        }

        if (this.exeName) {
            config["GameExe"] := this.exeName
        }

        if (this.launcherSpecificId) {
            config["GameLauncherSpecificId"] := this.launcherSpecificId
        }

        entity := LauncherEntity.new(launcherManager.app, this.key, config)
        launcherManager.AddLauncher(this.key, entity)
    }
}
