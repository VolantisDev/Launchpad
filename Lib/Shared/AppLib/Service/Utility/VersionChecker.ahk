class VersionChecker extends ServiceBase {
    VersionIsOutdated(latestVersion, installedVersion) {
        if (latestVersion == "{{VERSION}}") {
            return latestVersion != installedVersion
        }

        splitLatestVersion := StrSplit(latestVersion, ".")
        splitInstalledVersion := StrSplit(installedVersion, ".")

        for (index, numPart in splitInstalledVersion) {
            latestVersionPart := splitLatestVersion.Has(index) ? splitLatestVersion[index] : 0

            if ((latestVersionPart + 0) > (numPart + 0)) {
                return true
            } else if ((latestVersionPart + 0) < (numPart + 0)) {
                return false
            } 
        }

        return false
    }
}
