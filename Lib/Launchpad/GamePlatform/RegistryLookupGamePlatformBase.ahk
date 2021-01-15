class RegistryLookupGamePlatformBase extends GamePlatformBase {
    installDirRegView := 64
    installDirRegKey := ""
    installDirRegValue := "InstallLocation"
    exePathRegView := 64
    exePathRegKey := ""
    exePathRegValue := ""
    versionRegView := 64
    versionRegKey := ""
    versionRegValue := "DisplayVersion"
    uninstallCmdRegView := 64
    uninstallCmdRegKey := ""
    uninstallCmdRegValue := "UninstallString"

    __New(app, installDir := "", exePath := "", installedVersion := "", uninstallCmd := "", libraryDirs := "") {
        if (!installDir and this.installDirRegKey and this.installDirRegValue) {
            installDir := this.LookupRegValue(this.installDirRegView, this.installDirRegKey, this.installDirRegValue)
        }

        if (!exePath and this.exePathRegKey and this.exePathRegValue) {
            exePath := this.LookupRegValue(this.exePathRegView, this.exePathRegKey, this.exePathRegValue)
        }

        if (!installedVersion and this.versionRegKey and this.versionRegValue) {
            installedVersion := this.LookupRegValue(this.versionRegView, this.versionRegKey, this.versionRegValue)
        }

        if (!uninstallCmd and this.uninstallCmdRegKey and this.uninstallCmdRegValue) {
            uninstallCmd := this.LookupRegValue(this.uninstallCmdRegView, this.uninstallCmdRegKey, this.uninstallCmdRegValue)
        }

        super.__New(app, installDir, exePath, installedVersion, uninstallCmd, libraryDirs)
    }

    LookupRegValue(regView, regKey, regVal) {
        value := ""
        SetRegView(regView)

        try {
            value := RegRead(regKey, regVal)
        } catch ex {
            ; Do nothing
        }
        
        SetRegView("Default")

        if (SubStr(value, -1) == "\") {
            value := SubStr(value, 1, -1)
        }

        return value
    }
}
