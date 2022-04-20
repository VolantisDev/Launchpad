class VersionCheckerTest extends TestBase {
    versionCheckerInstance := ""

    Setup() {
        this.versionCheckerInstance := VersionChecker()
        ; super.Setup()
    }

    RunTestSteps() {
        this.TestFilterVersion()
        this.TestVersionIsOutdated()
    }

    TestFilterVersion() {
        this.TestMethod := "FilterVersion"
        upperVersion := "9999.9999.9999"

        this.AssertEquals(
            this.versionCheckerInstance.FilterVersion("0.0.0.0"), 
            upperVersion,
            "0.0.0.0 should filter to " . upperVersion
        )
        
        this.AssertEquals(
            this.versionCheckerInstance.FilterVersion("0.0.0.0"), 
            upperVersion,
            "{{VERSION}} should filter to " . upperVersion
        )

        for , version in [
            "1.2.3.4", 
            "0.1-beta1", 
            "99", 
            "1", 
            "0", 
            "24.1.5.6.0.4.23"
        ] {
            this.AssertEquals(
                this.versionCheckerInstance.FilterVersion(version), 
                version,
                version . " should filter to itself"
            )
        }

        this.TestMethod := ""
    }

    TestVersionIsOutdated() {
        this.TestMethod := "VersionIsOutdated"
        installedVersion := "1.0.0"

        this.AssertFalse(
            this.versionCheckerInstance.VersionIsOutdated("0.9.9", installedVersion),
            installedVersion . " is not outdated compared to version 0.9.9"
        )
        
        this.AssertFalse(
            this.versionCheckerInstance.VersionIsOutdated("0.0.1", installedVersion),
            installedVersion . " is not outdated compared to version 0.0.1"
        )
        
        this.AssertFalse(
            this.versionCheckerInstance.VersionIsOutdated("1.0.0", installedVersion),
            installedVersion . " is not outdated compared to version 1.0.0"
        )
        
        this.AssertTrue(
            this.versionCheckerInstance.VersionIsOutdated("1.0.1", installedVersion),
            installedVersion . " is outdated compared to version 1.0.1"
        )
        
        this.AssertTrue(
            this.versionCheckerInstance.VersionIsOutdated("2.0.0", installedVersion),
            installedVersion . " is outdated compared to version 2.0.0"
        )
        
        this.AssertTrue(
            this.versionCheckerInstance.VersionIsOutdated("0.0.0.0", installedVersion),
            installedVersion . " is outdated compared to version 0.0.0.0"
        )
        
        this.AssertTrue(
            this.versionCheckerInstance.VersionIsOutdated("{{VERSION}}", installedVersion),
            installedVersion . " is outdated compared to version {{VERSION}}"
        )
        
        this.TestMethod := ""
    }

    Teardown() {
        ; super.Teardown()
    }
}
