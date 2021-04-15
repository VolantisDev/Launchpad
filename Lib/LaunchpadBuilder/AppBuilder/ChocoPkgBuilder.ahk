class ChocoPkgBuilder extends AppBuilderBase {
    Build(version) {
        distDir := this.app.Config.DistDir
        installer := distDir . "\" . this.app.appName . "-" . this.app.Version . ".exe"

        if (!FileExist(installer)) {
            throw AppException.new("Installer file doesn't exist, cannot build chocolatey package.")
        }

        hash := this.app.Service("FileHasher").Hash(installer, FileHasher.HASH_TYPE_SHA256)

        if (!hash) {
            throw AppException.new("Failed to create an SHA256 hash of the installer file.")
        }

        this.ResetDistDir(distDir)
        this.WriteInstallScript(distDir, version, hash)
        this.CreateChocoPkg(distDir)
        return true
    }

    WriteInstallScript(distDir, version, hash) {
        chocoInstallFIle := distDir . "\chocolateyInstall.ps1"

        if (FileExist(chocoInstallFIle)) {
            FileDelete(chocoInstallFIle)
        }

        installerUrl := "https://github.com/" . this.app.Config.GitHubRepo . "/releases/download/" . version . "/" . this.app.appName . "-" . version . ".exe"
        pkgName := this.app.Config.ChocoPkgName
        FileAppend
        (
        "$packageName = '" . pkgName . "'
        $fileType = 'exe'
        $url = '" . installerUrl . "'
        $silentArgs = '/SD'
        $validExitCodes = @(0)
        
        Install-ChocolateyPackage `"$packageName`" `"$fileType`" `"$silentArgs`" `"$url`"  -validExitCodes  $validExitCodes  -checksum `"" . hash . "`" -checksumType `"sha256`"
        "
        ), chocoInstallFIle
    }

    CreateChocoPkg(distDir) {
        RunWait("choco pack", distDir)
    }

    ResetDistDir(distDir) {
        FileDelete(distDir . "\chocolatey*")
        FileDelete(distDir . "\*.nupkg")
    }
}
