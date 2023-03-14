class LaunchpadOverlayBuilder extends AppBuilderBase {
    name := "Launchpad Overlay"

    Build(version) {
        RunWait("msbuild LaunchpadOverlay.sln -property:Configuration=Release", this.app.appDir)

        outputExe := this.app.Config["build_dir"] . "\LaunchpadOverlay\LaunchpadOverlay.exe"

        if (!FileExist(outputExe)) {
            throw AppException("LaunchpadOverlay.exe failed to build.")
        }

        overlayDir := this.app.appDir . "\Resources\LaunchpadOverlay"

        if (DirExist(overlayDir)) {
            DirDelete(overlayDir, true)
        }

        DirCreate(overlayDir)
        FileCopy(outputExe, overlayDir . "\LaunchpadOverlay.exe")
        DirDelete(this.app.Config["build_dir"] . "\LaunchpadOverlay", true)
        return true
    }
}
