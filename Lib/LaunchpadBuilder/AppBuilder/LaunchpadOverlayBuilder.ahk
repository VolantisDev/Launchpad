class LaunchpadOverlayBuilder extends AppBuilderBase {
    Build(version) {
        RunWait("msbuild LaunchpadOverlay.sln -property:Configuration=Release", this.app.appDir)

        outputExe := this.app.Config.BuildDir . "\LaunchpadOverlay\LaunchpadOverlay.exe"

        if (!FileExist(outputExe)) {
            throw AppException.new("LaunchpadOverlay.exe failed to build.")
        }

        overlayDir := this.app.appDir . "\Resources\LaunchpadOverlay"

        if (DirExist(overlayDir)) {
            DirDelete(overlayDir, true)
        }

        DirCreate(overlayDir)
        FileCopy(outputExe, overlayDir . "\LaunchpadOverlay.exe")
        DirDelete(this.app.Config.BuildDir . "\LaunchpadOverlay", true)
        return true
    }
}
