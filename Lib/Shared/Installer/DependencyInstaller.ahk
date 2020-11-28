class DependencyInstaller extends InstallerBase {
    name := "Launchpad Dependency Installer"

    __New(appState, extraAssets := "", tmpDir := "") {
        assets := []

        dbVersion := "1.0.2"

        ahkUrl := "https://www.autohotkey.com/download/2.0/AutoHotkey_" . A_AhkVersion . ".zip"
        ahkPath := "Vendor\AutoHotKey"
        ahkAsset := DownloadableInstallerAsset.new(ahkUrl, true, ahkPath, appState, "AutoHotKey", "Dependencies", true, tmpDir)
        ahkAsset.version := A_AhkVersion
        assets.Push(ahkAsset)

        mpressUrl := "https://github.com/bmcclure/launcher-db/releases/download/" . dbVersion . "/mpress.exe"
        mpressPath := "Vendor\AutoHotKey\Compiler\mpress.exe"
        mpressAsset := DownloadableInstallerAsset.new(mpressUrl, false, mpressPath, appState, "Mpress", "AutoHotKey", true, tmpDir)
        mpressAsset.version := dbVersion
        assets.Push(mpressAsset)

        ahk2ExeUrl := "https://github.com/bmcclure/launcher-db/releases/download/" . dbVersion . "/Ahk2Exe.exe"
        ahk2ExePath := "Vendor\AutoHotKey\Compiler\Ahk2Exe.exe"
        ahk2ExeAsset := DownloadableInstallerAsset.new(ahk2ExeUrl, false, ahk2ExePath, appState, "Ahk2Exe", "AutoHotKey", true, tmpDir)
        ahk2ExeAsset.version := dbVersion
        assets.Psuh(ahk2ExeAsset)

        asset := GitHubReleaseInstallerAsset.new("dafzor/bnetlauncher", "", true, "Vendor\BnetLauncher", appState, "BnetLauncher", "Dependencies", true, tmpDir)
        asset.version := this.version
        assets.Push(asset)

        assetUrl := "https://benmcclure.com/launcher-db/Assets/Dependencies/BnetLauncher/gamedb.ini"
        assetPath := "Vendor\BnetLauncher\gamedb.ini"
        asset := DownloadableInstallerAsset.new(assetUrl, false, assetPath, appState, "GameDbIni", "BnetLauncher", true, tmpDir)

        iconsExtUrl := "https://www.nirsoft.net/utils/iconsext.zip"
        iconsExtPath := "Vendor\IconsExt"
        assets.Push(DownloadableInstallerAsset.new(iconsExtUrl, true, iconsExtPath, "IconsExt", "Dependencies", false, tmpDir))

        if (extraAssets != "") {
            for index, asset in extraAssets) {
                assets.Push(asset)
            }
        }

        super.__New(appState, "Dependencies", assets, tmpDir := "")
    }
}
