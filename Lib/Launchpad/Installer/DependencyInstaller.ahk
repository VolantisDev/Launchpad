class DependencyInstaller extends InstallerBase {
    name := "Dependency Installer"
    installerType := InstallerBase.INSTALLER_TYPE_REQUIREMENT

    __New(version, appState, cacheManager, cacheName, extraComponents := "", tmpDir := "") {
        ; TODO: Remove dependency on A_ScriptDir
        installDir := A_ScriptDir
        components := []
        cleanupFiles := []

        cache := cacheManager[cacheName]

        ahkUrl := "https://www.autohotkey.com/download/2.0/AutoHotkey_" . A_AhkVersion . ".zip"
        components.Push(DownloadableInstallerComponent(A_AhkVersion, ahkUrl, true, "Vendor\AutoHotKey", appState, "AutoHotKey", cache, "Dependencies", true, tmpDir, false))
        
        ahkDir := installDir . "\Vendor\AutoHotKey"
        cleanupFiles.Push(ahkDir . "\AutoHotKeyU32.exe")
        cleanupFiles.Push(ahkDir . "\AutoHotKeyU64.exe")
        cleanupFiles.Push(ahkDir . "\Compiler\Unicode 32-bit.bin")
        cleanupFiles.Push(ahkDir . "\Compiler\Unicode 64-bit.bin")

        ahkBins := installDir . "\Resources\Dependencies\AHkBins.zip"
        dest := ahkDir . "\Compiler"
        ahkBinsComponent := CopyableInstallerComponent(A_AhkVersion, ahkBins, true, dest, appState, "AhkBins", cache, "Dependencies", true, tmpDir, false, "Ahk2Exe.exe")
        components.Push(ahkBinsComponent)

        iconsExtUrl := "https://www.nirsoft.net/utils/iconsext.zip"
        iconsExtPath := "Vendor\IconsExt"
        components.Push(DownloadableInstallerComponent(this.version, iconsExtUrl, true, iconsExtPath, appState, "IconsExt", cache, "Dependencies", false, tmpDir, false))

        protobufVersion := "3.14.0"
        protocAssetName := FileExist("C:\Program Files (x86)") ? "protoc-" . protobufVersion . "-win64.zip" : "protoc-" . protobufVersion . "-win32.zip"
        components.Push(GitHubReleaseInstallerComponent("v" . protobufVersion, "protocolbuffers/protobuf", protocAssetName, true, "Vendor\Protoc", appState, "Protoc", cache, "Dependencies", true, tmpDir, false, true))

        if (extraComponents != "") {
            for index, component in extraComponents {
                components.Push(component)
            }
        }

        super.__New(version, appState, "Dependencies", cacheManager, cacheName, components, tmpDir, cleanupFiles)
    }
}
