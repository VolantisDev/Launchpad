class GameExeLocator extends FileLocator {
    InitializeFilters() {
        this.AddFilter("UnityCrashHandler64.exe")
        this.AddFilter("UnityCrashHandler32.exe")
        this.AddFilter("UnityCrashHandler.exe")
        this.AddFilter("OriginThinSetup.exe")
        this.AddFilter("vc_redist.x64.exe")
        this.AddFilter("vc_redist.x86.exe")
        this.AddFilter("vcredist_x86.exe")
        this.AddFilter("vcredist_x64.exe")
        this.AddFilter("vc_redist_2015_x64.exe")
        this.AddFilter("overlayinjector.exe")
        this.AddFilter("Cleanup.exe")
        this.AddFilter("Touchup.exe")
        this.AddFilter("ActivationUI.exe")
        this.AddFilter("DXSETUP.exe")
        this.AddFilter("BlizzardBrowser.exe")
        this.AddFilter("UnSetupNativeWrapper.exe")
        this.AddFilter("UnrealLightmass.exe")
        this.AddFilter("UE3ShaderCompileWorker.exe")
        this.AddFilter("QuickTimeUpdateHelper.exe")
        this.AddFilter("QTPluginInstaller.exe")
        this.AddFilter("CrashReporter.exe")
        this.AddFilter("CrashReportClient.exe")
        this.AddFilter("CefSharp.BrowserSubprocess.exe")
        this.AddFilter("ReportCodBug.exe")
        this.AddFilter("dxwebsetup.exe")
        this.AddFilter("EasyAntiCheat_Setup.exe")
        this.AddFilter("UnrealCEFSubProcess.exe")
        this.AddFilter("setup_redlauncher.exe") ; Added for CP2077
        this.AddFilter("REDEngineErrorReporter.exe") ; Added for CP2077
        this.AddFilter("REDprelauncher.exe") ; Added for CP2077
        this.AddFilter("7za.exe")
        this.AddFilter("breakpad_server.exe") ; Added for Detroit: Become Human
        this.AddFilter("vconsole2.exe") ; Added for Half-Life: Alyx
        this.AddFilter("bspzip.exe")
        this.AddFilter("captioncompiler.exe")
        this.AddFilter("demoinfo.exe")
        this.AddFilter("UNSTALL.EXE")
        this.AddFilter("SETSOUND.EXE")
        this.AddFilter("dosbox.exe")
        this.AddFilter("QtWebEngineProcess.exe")
        this.AddFilter("Benchmark.exe")
        this.AddFilter("CrashUploader.Publish.exe")
        this.AddFilter("ipy64.exe")
        this.AddFilter("ipy.exe")
        this.AddFilter("sysinfo.exe")
        this.AddFilter("register.exe")
        this.AddFilter("LuaCompiler.exe")
        this.AddFilter("sandboxpython.exe")
        this.AddFilter("BlizzardError.exe")
        this.AddFilter("CrashMailer_64.exe")
        this.AddFilter("CrashMailer.exe")

        this.AddFilter("__Installer", "PathPart")
        this.AddFilter("DotNetCore", "PathPart")
        this.AddFilter("Redist", "PathPart")
        this.AddFilter("Redistributables", "PathPart")
        this.AddFilter("ModTools", "PathPart")
        this.AddFilter("mono", "PathPart")
        this.AddFilter("test", "PathPart")
    }

    FilterPattern(pattern) {
        if (!pattern) {
            pattern := "*.exe"
        }
        
        return pattern
    }
}
