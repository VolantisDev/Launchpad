class RiotPlatform extends RegistryLookupGamePlatformBase {
    displayName := "Epic"
    launcherType := "Epic"
    gameType := "Epic"
    installDirRegView := 32
    installDirRegKey := "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{0E63B233-DC24-442C-BD38-0B91D90FEC5B}"
    versionRegView := 32
    versionRegKey := "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{0E63B233-DC24-442C-BD38-0B91D90FEC5B}"
    uninstallCmdRegView := 32
    uninstallCmdRegKey := "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{0E63B233-DC24-442C-BD38-0B91D90FEC5B}"

    Install() {
        Run("https://www.epicgames.com/store/en-US/download")
    }
}
