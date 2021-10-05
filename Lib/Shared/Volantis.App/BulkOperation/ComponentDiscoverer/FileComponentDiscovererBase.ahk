class FileComponentDiscovererBase extends ComponentDiscovererBase {
    searchDirs := ""
    filePattern := ""

    __New(componentManager, searchDirs, filePattern := "", owner := "") {
        if (Type(searchDirs) != "Array") {
            searchDirs := [searchDirs]
        }

        if (!filePattern) {
            filePattern := "*"
        }

        this.searchDirs := searchDirs
        this.filePattern := filePattern

        super.__New(componentManager, owner)
    }

    DiscoverComponents() {
        for index, dir in this.searchDirs {
            Loop Files dir . "\" . this.filePattern, "R" {
                this.DiscoverComponent(A_LoopFileName, A_LoopFileFullPath)
            }
        }

        super.DiscoverComponents()
    }

    DiscoverComponent(fileName, filePath) {
        throw MethodNotImplementedException("FileComponentDiscovererBase", "DiscoverComponent")
    }
}
