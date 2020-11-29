class DependencyInstaller extends InstallerBase {
    name := "Launchpad Dependency Installer"
    version := "latest"

    __New(appState, cache, extraAssets := "", tmpDir := "") {
        assets := []

        dbVersion := "1.0.2"

        ahkUrl := "https://www.autohotkey.com/download/2.0/AutoHotkey_" . A_AhkVersion . ".zip"
        ahkPath := "Vendor\AutoHotKey"
        ahkAsset := DownloadableInstallerAsset.new(ahkUrl, true, ahkPath, appState, "AutoHotKey", cache, "Dependencies", true, tmpDir, false)
        ahkAsset.version := A_AhkVersion
        assets.Push(ahkAsset)

        mpressUrl := "https://github.com/bmcclure/launcher-db/releases/download/" . dbVersion . "/mpress.exe"
        mpressPath := "Vendor\AutoHotKey\Compiler\mpress.exe"
        mpressAsset := DownloadableInstallerAsset.new(mpressUrl, false, mpressPath, appState, "Mpress", cache, "AutoHotKey", true, tmpDir, false)
        mpressAsset.version := dbVersion
        assets.Push(mpressAsset)

        ahk2ExeUrl := "https://github.com/bmcclure/launcher-db/releases/download/" . dbVersion . "/Ahk2Exe.exe"
        ahk2ExePath := "Vendor\AutoHotKey\Compiler\Ahk2Exe.exe"
        ahk2ExeAsset := DownloadableInstallerAsset.new(ahk2ExeUrl, false, ahk2ExePath, appState, "Ahk2Exe", cache, "AutoHotKey", true, tmpDir, false)
        ahk2ExeAsset.version := dbVersion
        assets.Push(ahk2ExeAsset)

        assets.Push(GitHubReleaseInstallerAsset.new("dafzor/bnetlauncher", "", true, "Vendor\BnetLauncher", appState, "BnetLauncher", cache, "Dependencies", true, tmpDir, false))

        assetUrl := "https://benmcclure.com/launcher-db/Assets/Dependencies/BnetLauncher/gamedb.ini"
        assetPath := "Vendor\BnetLauncher\gamedb.ini"
        assets.Push(DownloadableInstallerAsset.new(assetUrl, false, assetPath, appState, "GameDbIni", cache, "BnetLauncher", true, tmpDir, false))

        iconsExtUrl := "https://www.nirsoft.net/utils/iconsext.zip"
        iconsExtPath := "Vendor\IconsExt"
        assets.Push(DownloadableInstallerAsset.new(iconsExtUrl, true, iconsExtPath, appState, "IconsExt", cache, "Dependencies", false, tmpDir, false))

        if (extraAssets != "") {
            for (index, asset in extraAssets) {
                assets.Push(asset)
            }
        }

        super.__New(appState, "Dependencies", cache, assets, tmpDir := "")
    }
}
