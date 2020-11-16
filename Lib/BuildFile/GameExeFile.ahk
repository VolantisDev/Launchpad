class GameExeFile extends ComposableBuildFile {
    __New(app, config, launcherDir, key, filePath := "", autoBuild := true) {
        base.__New(app, config, launcherDir, key, ".exe", filePath, autoBuild)
    }

    ComposeFile() {
        SplitPath, % this.FilePath,,dir,,nameNoExt

        exeBase := dir

        if (this.app.AppConfig.IndividualDirs) {
            exeBase := exeBase . "\" . nameNoExt
        }

        assetsDir := this.app.AppConfig.AssetsDir

        if (assetsDir != "") {
            base := assetsDir  . "\" . nameNoExt
        } else {
            base := dir

            if (this.app.AppConfig.IndividualDirs) {
                base := base . "\" . nameNoExt
            }
        }

        exePath := exeBase . ".exe"
        iconPath := base . ".ico"
        ahkPath := base . ".ahk"
        
        ahk2ExePath := this.app.AppConfig.AppDir . "\Vendor\AutoHotKey\Compiler\Ahk2Exe.exe"
        
        RunWait, %ahk2ExePath% /in "%ahkPath%" /out "%exePath%" /icon "%iconPath%"
    }
}
