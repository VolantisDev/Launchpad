class VersionCheckerTest extends TestBase {
    versionCheckerInstance := ""

    Setup() {
        this.versionCheckerInstance := VersionChecker()
        super.Setup()
    }

    Run() {
        this.TestFilterVersion()
        this.TestVersionIsOutdated()
        super.Run()
    }

    TestFilterVersion() {
        upperVersion := "9999.9999.9999"

        this.AssertEquals("Version 0.0.0.0 should filter to " . upperVersion, this.versionCheckerInstance.FilterVersion("0.0.0.0"), upperVersion)
        this.AssertEquals("Version {{VERSION}} should filter to " . upperVersion, this.versionCheckerInstance.FilterVersion("0.0.0.0"), upperVersion)
        
        versions := ["1.2.3.4", "0.1-beta1", "99", "1", "0", "24.1.5.6.0.4.23"]

        for (index, version in versions) {
            this.AssertEquals("Version " . version . " should filter to itself", this.versionCheckerInstance.FilterVersion(version), version)
        }
    }

    TestVersionIsOutdated() {
        installedVersion := "1.0.0"

        this.AssertFalse("Version " . installedVersion . " is not outdated compared to version 0.9.9", this.versionCheckerInstance.VersionIsOutdated("0.9.9", installedVersion))
        this.AssertFalse("Version " . installedVersion . " is not outdated compared to version 0.0.1", this.versionCheckerInstance.VersionIsOutdated("0.0.1", installedVersion))
        this.AssertFalse("Version " . installedVersion . " is not outdated compared to version 1.0.0", this.versionCheckerInstance.VersionIsOutdated("1.0.0", installedVersion))
        this.AssertTrue("Version " . installedVersion . " is outdated compared to version 1.0.1", this.versionCheckerInstance.VersionIsOutdated("1.0.1", installedVersion))
        this.AssertTrue("Version " . installedVersion . " is outdated compared to version 2.0.0", this.versionCheckerInstance.VersionIsOutdated("2.0.0", installedVersion))
        this.AssertTrue("Version " . installedVersion . " is outdated compared to version 0.0.0.0", this.versionCheckerInstance.VersionIsOutdated("0.0.0.0", installedVersion))
        this.AssertTrue("Version " . installedVersion . " is outdated compared to version {{VERSION}}", this.versionCheckerInstance.VersionIsOutdated("{{VERSION}}", installedVersion))
    }

    Teardown() {
        super.Teardown()
    }
}
