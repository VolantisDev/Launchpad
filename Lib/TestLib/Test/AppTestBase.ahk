class AppTestBase extends TestBase {
    testAppVersion := "1.23.45"
    testAppInstance := ""
    requiresTestApp := false

    GetTestAppConfig() {
        config := Map(
            "appName", "Test App",
            "appDir", A_ScriptDir,
            "tmpDir", this.testDir . "\Temp",
            "dataDir", this.testDir . "\Data",
            "version", this.testAppVersion,
            "parameters", Map(
                "app.developer", "Test Developer",
                "config.flush_cache_on_exit", false,
                "config.logging_level", "none",
                "config.module_dirs", [],
            ),
            "services", Map(
                "config.app", Map(
                    "class", "RuntimeConfig",
                    "arguments", [ContainerRef(), ParameterRef("config_key")]
                )
            )
        )

        return config
    }

    Setup() {
        this.CreateTestDir()
        this.StartTestApp()
        this.CreateTestInstances()
    }

    Teardown() {
        this.StopTestApp()
        super.Teardown()
    }

    StartTestApp() {
        if (this.requiresTestApp) {
            this.testAppInstance := TestApp(this.GetTestAppConfig())
        }
    }

    StopTestApp() {
        if (this.requiresTestApp && this.testAppInstance) {
            this.testAppInstance.ExitApp()
        }
    }
}
