class DependencyInstaller extends InstallerBase {
    name := "Dependency Installer"

    __New(version, appState, cache, extraComponents := "", tmpDir := "") {
        components := []
        dbVersion := "1.0.2"

        ahkUrl := "https://www.autohotkey.com/download/2.0/AutoHotkey_" . A_AhkVersion . ".zip"
        components.Push(DownloadableInstallerComponent.new(A_AhkVersion, ahkUrl, true, "Vendor\AutoHotKey", appState, "AutoHotKey", cache, "Dependencies", true, tmpDir, false))

        ;mpressUrl := "https://github.com/bmcclure/launcher-db/releases/download/" . dbVersion . "/mpress.exe"
        ;mpressPath := "Vendor\AutoHotKey\Compiler\mpress.exe"
        ;mpressComponent := DownloadableInstallerComponent.new(dbVersion, mpressUrl, false, mpressPath, appState, "Mpress", cache, "AutoHotKey", true, tmpDir, false)
        ;components.Push(mpressComponent)

        ;ahk2ExeUrl := "https://github.com/bmcclure/launcher-db/releases/download/" . dbVersion . "/Ahk2Exe.exe"
        ;ahk2ExePath := "Vendor\AutoHotKey\Compiler\Ahk2Exe.exe"
        ;ahk2ExeComponent := DownloadableInstallerComponent.new(dbVersion, ahk2ExeUrl, false, ahk2ExePath, appState, "Ahk2Exe", cache, "AutoHotKey", true, tmpDir, false)
        ;components.Push(ahk2ExeComponent)

        ; TODO: Remove dependency on A_ScriptDir
        ahkBins := A_ScriptDir . "\Resources\Dependencies\AHkBins.zip"
        dest := A_ScriptDir . "\Vendor\AutoHotKey\Compiler"
        ahkBinsComponent := CopyableInstallerComponent.new(dbVersion, ahkBins, true, dest, appState, "AhkBins", cache, "Dependencies", true, tmpDir, false, "Ahk2Exe.exe")
        components.Push(ahkBinsComponent)

        iconsExtUrl := "https://www.nirsoft.net/utils/iconsext.zip"
        iconsExtPath := "Vendor\IconsExt"
        components.Push(DownloadableInstallerComponent.new(this.version, iconsExtUrl, true, iconsExtPath, appState, "IconsExt", cache, "Dependencies", false, tmpDir, false))

        protobufVersion := "3.14.0"
        protocAssetName := FileExist("C:\Program Files (x86)") ? "protoc-" . protobufVersion . "-win64.zip" : "protoc-" . protobufVersion . "-win32.zip"
        components.Push(GitHubReleaseInstallerComponent.new("v" . protobufVersion, "protocolbuffers/protobuf", protocAssetName, true, "Vendor\Protoc", appState, "Protoc", cache, "Dependencies", true, tmpDir, false, true))

        if (extraComponents != "") {
            for (index, component in extraComponents) {
                components.Push(component)
            }
        }

        super.__New(version, appState, "Dependencies", cache, components, tmpDir := "")
    }
}
