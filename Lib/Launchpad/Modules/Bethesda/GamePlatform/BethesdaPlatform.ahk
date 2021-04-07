class BethesdaPlatform extends RegistryLookupGamePlatformBase {
    key := "Bethesda"
    displayName := "Bethesda.net"
    launcherType := "Bethesda"
    gameType := "Default"
    installDirRegView := 32
    installDirRegKey := "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{3448917E-E4FE-4E30-9502-9FD52EABB6F5}_is1"
    versionRegView := 32
    versionRegKey := "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{3448917E-E4FE-4E30-9502-9FD52EABB6F5}_is1"
    uninstallCmdRegView := 32
    uninstallCmdRegKey := "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{3448917E-E4FE-4E30-9502-9FD52EABB6F5}_is1"

    Install() {
        Run("https://bethesda.net/en/game/bethesda-launcher")
    }

    GetLibraryDirs() {
        libraryDirs := super.GetLibraryDirs()
        installDir := this.GetInstallDir()

        if (installDir && !this.LibraryDirExists(installDir . "\games")) {
            libraryDirs.Push(installDir . "\games")
        }

        return libraryDirs
    }

    DetectInstalledGames() {
        ; TODO: Find a config source to read bethesda game directories from
        return super.DetectInstalledGames()
    }

    GetExePath() {
        exePath := super.GetExePath()

        if (!exePath) {
            installDir := this.GetInstallDir()

            if (installDir) {
                exePath := installDir . "\BethesdaNetLauncher.exe"
            }
        }

        return exePath
    }
}
