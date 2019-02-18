class ExeBuilder {
    app := {}

    __New(app) {
        this.app := app
    }

    BuildExe(key) {
        base := this.app.AppConfig.LauncherDir . "\" . key . "\" . key
        iconPath := base . ".ico"
        ahkPath := base . ".ahk"
        exePath := base . ".exe"
        ahk2ExePath := this.app.AppConfig.AppDir . "\Vendor\AutoHotKey\Compiler\Ahk2Exe.exe"
        
        FileDelete, %exePath%
        RunWait, %ahk2ExePath% /in "%ahkPath%" /out "%exePath%" /icon "%iconPath%"

        return true
    }
}
