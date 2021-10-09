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
        if (!installDir && this.installDirRegKey && this.installDirRegValue) {
            installDir := this.LookupRegValue(this.installDirRegView, this.installDirRegKey, this.installDirRegValue)
        }

        if (!exePath && this.exePathRegKey && this.exePathRegValue) {
            exePath := this.LookupRegValue(this.exePathRegView, this.exePathRegKey, this.exePathRegValue)
        }

        if (!installedVersion && this.versionRegKey && this.versionRegValue) {
            installedVersion := this.LookupRegValue(this.versionRegView, this.versionRegKey, this.versionRegValue)
        }

        if (!uninstallCmd && this.uninstallCmdRegKey && this.uninstallCmdRegValue) {
            uninstallCmd := this.LookupRegValue(this.uninstallCmdRegView, this.uninstallCmdRegKey, this.uninstallCmdRegValue)
        }

        super.__New(app, installDir, exePath, installedVersion, uninstallCmd, libraryDirs)
    }

    LookupRegValue(regView, regKey, regVal) {
        value := ""
        SetRegView(regView)

        try {
            value := RegRead(regKey, regVal)
        } catch Any {
            ; Do nothing
        }
        
        SetRegView("Default")

        if (SubStr(value, -1) == "\") {
            value := SubStr(value, 1, -1)
        }

        return value
    }
}
