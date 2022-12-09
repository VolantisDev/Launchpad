class VersionChecker {
    VersionIsOutdated(latestVersion, installedVersion) {
        return (this.VersionCompare(latestVersion, installedVersion) == 1)
    }

    FilterVersion(version) {
        if (version == "0.0.0.0" || version == "{{VERSION}}") {
            version := "9999.9999.9999"
        }

        return version
    }

    VersionMatches(version, constraints := "") {
        version := this.FilterVersion(version)

        if (constraints == "" || constraints == "*" || constraints == version) {
            return true
        }

        constraints := StrReplace(constraints, " ||", "||")
        constraints := StrReplace(constraints, "|| ", "||")
        constraints := StrReplace(constraints, " -", "-")
        constraints := StrReplace(constraints, "- ", "-")
        constraints := StrReplace(constraints, " ", ",")

        orGroups := StrSplit(constraints, "||")

        compatible := false

        for , group in orGroups {
            constraintItems := StrSplit(group, ",")
            andMatch := true

            for , constraint in constraintItems {
                if (!this.ConstraintMatches(version, constraint)) {
                    andMatch := false

                    break
                }
            }

            if (andMatch) {
                compatible := true
            }
        }

        return compatible
    }

    ConstraintMatches(version, constraint) {
        version := this.FilterVersion(version)
        compatible := true

        constraint := Trim(constraint)

        if (constraint != "" && constraint != "*" && constraint != version) {
            minVersion := ""
            minEqual := false
            maxVersion := ""
            maxEqual := false
            notVersion := ""
            newConstraints := []

            if (InStr(constraint, "~") == 1 || InStr(constraint, "^") == 1) {
                op := SubStr(constraint, 1, 1)
                minVersion := SubStr(constraint, 2)
                minEqual := true
                versionArr := StrSplit(constraint, "-")
                suffix := versionArr.Length > 1 ? versionArr[2] : ""
                versionArr := StrSplit(versionArr[1], ".")
                incrementIndex := 1

                if (op == "~") {
                    if (versionArr.Length == 1) {
                        versionArr.Push("0")
                    }

                    incrementIndex := versionArr.Length - 1
                } else if (versionArr[0] == "0") {
                    incrementIndex := versionArr.Length
                }

                versionArr[incrementIndex] += 1

                for , part in versionArr {
                    if (maxVersion) {
                        maxVersion := maxVersion . "."
                    }

                    maxVersion := maxVersion . part
                }

                if (suffix) {
                    maxVersion := maxVersion . "-" . suffix
                }
            } else if (InStr(constraint, ">=") == 1) {
                minVersion := SubStr(constraint, 3)
                minEqual := true
            } else if (InStr(constraint, ">") == 1) {
                minVersion := SubStr(constraint, 2)
            } else if (InStr(constraint, "<=") == 1) {
                maxVersion := SubStr(constraint, 3)
                maxEqual := true
            } else if (InStr(constraint, "<") == 1) {
                maxVersion := SubStr(constraint, 2)
            } else if (InStr(constraint, "!=") == 1) {
                notVersion := SubStr(constraint, 3)
            }

            compareResult := this.VersionCompare(version, minVersion)

            if (newConstraints && compatible) {
                compatible := true

                for , newConstraint in newConstraints {
                    if (!this.ConstraintMatches(version, newConstraint)) {
                        compatible := false
                        break
                    }
                }
            }
            
            if (notVersion && compatible) {
                compatible := compareResult != 0
            }
            
            if (minVersion && compatible) {
                compatible := (compareResult == 1 || (minEqual && compareResult == 0))
            }
            
            if (maxVersion && compatible) {
                compatible := (compareResult == -1 || (maxEqual && compareResult == 0))
            }
        }

        return compatible
    }

    ValidateVersion(version) {
        version := this.FilterVersion(version)
        return !!RegExMatch(version, "^(\d+)\.(\d+)\.(\d+)(\-([0-9A-Za-z\-]+\.)*[0-9A-Za-z\-]+)?(\+([0-9A-Za-z\-]+\.)*[0-9A-Za-z\-]+)?$")
    }
    
    SplitVersion(version) {
        version := this.FilterVersion(version)
        major := 0
        minor := 0
        patch := 0
        prerelease := ""
        build := ""
    
        matches := ""
    
        isValid := !!RegExMatch(version, "^(?P<major>\d+)\.(?P<minor>\d+)\.(?P<patch>\d+)(\-(?P<prerelease>([0-9A-Za-z\-]+\.)*([0-9A-Za-z\-]+)))?(\+?(?P<build>([0-9A-Za-z\-]+\.)*([0-9A-Za-z\-]+)))?$", &matches)
    
        if (matches) {
            for key, match in matches {
                name := matches.Name[key]
    
                if (name) {
                    %name% := match
                }
            }
        }
    
        return Map(
            "valid", isValid,
            "major", major,
            "minor", minor,
            "patch", patch,
            "prerelease", prerelease,
            "build", build
        )
    }
    
    VersionCompare(version1, version2) {
        v1 := this.SplitVersion(this.FilterVersion(version1))
        v2 := this.SplitVersion(this.FilterVersion(version2))
    
        if (!v1["valid"])  {
            throw AppException("Invalid version: " version1)
        }
    
        if (!v2["valid"]) {
            throw AppException("Invalid version: " version2)
        }
    
        for , part in ["major", "minor", "patch"] {
            if (!IsNumber(v1[part])) {
                v1[part] := 0
            }
    
            if (!IsNumber(v2[part])) {
                v2[part] := 0
            }
    
            v1[part] += 0
            v2[part] += 0
    
            if (v1[part] < v2[part]) {
                return -1
            } else if (v1[part] > v2[part]) {
                return +1
            }
        }
    
        for , part in ["prerelease", "build"] {
            if (v1[part] && v2[part]) {
                split1 := StrSplit(v1[part], ".")
                split2 := StrSplit(v2[part], ".")
    
                len := split1.Length
    
                if (split2.Length > len) {
                    len := split2.Length
                }
    
                Loop len {
                    val1 := split1.Has(A_Index) ? split1[A_Index] : ""
                    val2 := split2.Has(A_Index) ? split2[A_Index] : ""
    
                    if (IsDigit(val1) && IsDigit(val2)) {
                        val1 += 0
                        val2 += 0
                        
                        if (val1 < val2) {
                            return -1
                        } else if (val1 > val2) {
                            return +1
                        }
    
                        continue
                    }
    
                    if (val1 < val2) {
                        return -1
                    } if (val1 > val2) {
                        return +1
                    }
                }
    
                if (split1.Length < split2.Length) {
                    return -1
                } else if (split1.Length > split2.Length) {
                    return +1
                }
            } else if (!v1[part] && v2[part]) {
                return (part == "prerelease") ? +1 : -1
            } else if (v1[part] && !v2[part]) {
                return (part == "prerelease") ? -1 : +1
            }
        }
    
        return 0
    }
}
