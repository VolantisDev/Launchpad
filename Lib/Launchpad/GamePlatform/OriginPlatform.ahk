class OriginPlatform extends RegistryLookupGamePlatformBase {
    key := "Origin"
    displayName := "Origin"
    launcherType := "Origin"
    gameType := "Default"
    installDirRegView := 32
    installDirRegKey := "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Origin"
    versionRegView := 32
    versionRegKey := "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Origin"
    uninstallCmdRegView := 32
    uninstallCmdRegKey := "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Origin"

    Install() {
        Run("https://www.origin.com/usa/en-us/store/download")
    }

    GetLibraryDirs() {
        libraryDirs := super.GetLibraryDirs()

        xmlPath := A_AppData . "\Origin\local.xml"

        if (FileExist(xmlPath)) {
            xmlFile := Xml.FromFile(xmlPath)
            node := xmlFile.selectSingleNode("/Settings/Setting[@key='DownloadInPlaceDir']")
            dir := node.getAttribute("value")

            if (dir && !this.LibraryDirExists(dir)) {
                libraryDirs.Push(dir)
            }
        }

        return libraryDirs
    }

    DetectInstalledGames() {
        ; @todo Replace with functionality that reads from a config source
        return super.DetectInstalledGames()
    }

    GetExePath() {
        exePath := super.GetExePath()

        if (!exePath) {
            installDir := this.GetInstallDir()

            if (installDir) {
                exePath := installDir . "\Origin.exe"
            }
        }

        return exePath
    }
}
