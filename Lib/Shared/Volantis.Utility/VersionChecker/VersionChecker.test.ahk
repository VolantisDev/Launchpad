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

        this.AssertEquals("FilterVersion", this.versionCheckerInstance.FilterVersion("0.0.0.0"), upperVersion)
        this.AssertEquals("FilterVersion", this.versionCheckerInstance.FilterVersion("0.0.0.0"), upperVersion)
        
        versions := ["1.2.3.4", "0.1-beta1", "99", "1", "0", "24.1.5.6.0.4.23"]

        for (index, version in versions) {
            this.AssertEquals("FilterVersion", this.versionCheckerInstance.FilterVersion(version), version)
        }
    }

    TestVersionIsOutdated() {
        installedVersion := "1.0.0"

        this.AssertFalse("VersionIsOutdated", this.versionCheckerInstance.VersionIsOutdated("0.9.9", installedVersion))
        this.AssertFalse("VersionIsOutdated", this.versionCheckerInstance.VersionIsOutdated("0.0.1", installedVersion))
        this.AssertFalse("VersionIsOutdated", this.versionCheckerInstance.VersionIsOutdated("1.0.0", installedVersion))
        this.AssertTrue("VersionIsOutdated", this.versionCheckerInstance.VersionIsOutdated("1.0.1", installedVersion))
        this.AssertTrue("VersionIsOutdated", this.versionCheckerInstance.VersionIsOutdated("2.0.0", installedVersion))
        this.AssertTrue("VersionIsOutdated", this.versionCheckerInstance.VersionIsOutdated("0.0.0.0", installedVersion))
        this.AssertTrue("VersionIsOutdated", this.versionCheckerInstance.VersionIsOutdated("{{VERSION}}", installedVersion))
    }

    Teardown() {
        super.Teardown()
    }
}
