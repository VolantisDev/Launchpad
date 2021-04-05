class FileLocator extends LocatorBase {
    filters := []
    searchDirs := []
    
    __New(searchDirs, config := "") {
        if (Type(searchDirs) != "Array") {
            searchDirs := [searchDirs]
        }

        this.searchDirs := searchDirs
        this.InitializeFilters()
        super.__New(config)
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
        return !!(FileExist(fullPath))
    }

    FilterPattern(pattern) {
        return pattern
    }
}
