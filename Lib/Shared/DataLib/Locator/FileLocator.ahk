class FileLocator extends LocatorBase {
    filters := []
    searchDirs := []
    
    __New(searchDirs, config := "") {
        if (Type(searchDirs) != "Array") {
            searchDirs := [searchDirs]
        }

        this.searchDirs := searchDirs
        super.__New(config)
        this.InitializeFilters()
    }

    InitializeFilters() {

    }

    AddFilter(pattern, typeVal := "Filename") {
        this.filters.Push(Map("pattern", pattern, "type", typeVal))
        return this
    }
    
    Locate(pattern) {
        results := []
        
        if (this.searchDirs) {
            for index, dir in this.searchDirs {
                Loop Files dir . "\" . this.FilterPattern(pattern), "R" {
                    if (this.ResultIsValid(A_LoopFileName, A_LoopFileFullPath)) {
                        results.Push(A_LoopFileFullPath)
                    }
                }
            }
        }

        return results
    }

    ResultIsValid(filename, fullPath) {
        isValid := !!(FileExist(fullPath))

        if (isValid) {
            for index, filter in this.filters {
                if (filter["type"] == "Filename") {
                    if (StrLower(filename) == StrLower(filter["pattern"])) {
                        isValid := false
                        break
                    }
                } else if (filter["type"] == "PathPart") {
                    if (InStr(fullPath, "\" . filter["pattern"] . "\")) {
                        isValid := false
                        break
                    }
                }
            }
        }

        return isValid
    }

    FilterPattern(pattern) {
        return pattern
    }
}
