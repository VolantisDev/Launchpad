class VersionChecker {
    VersionIsOutdated(latestVersion, installedVersion) {
        splitLatestVersion := StrSplit(this.FilterVersion(latestVersion), ".")
        splitInstalledVersion := StrSplit(this.FilterVersion(installedVersion), ".")

        for index, numPart in splitInstalledVersion {
            latestVersionPart := splitLatestVersion.Has(index) ? splitLatestVersion[index] : 0

            if ((latestVersionPart + 0) > (numPart + 0)) {
                return true
            } else if ((latestVersionPart + 0) < (numPart + 0)) {
                return false
            } 
        }

        return false
    }

    FilterVersion(version) {
         if (version == "0.0.0.0" || version == "{{VERSION}}") {
            version := "9999.9999.9999"
        }

        return version
    }
}
