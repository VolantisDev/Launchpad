class FileDiscoveryDefinitionLoaderBase extends DefinitionLoaderBase {
    searchDirs := ""
    fileSuffix := ""
    recursive := ""
    services := ""
    parameters := ""


    __New(searchDirs, fileSuffix := "", recursive := false) {
        if (!HasBase(searchDirs, Array.Prototype)) {
            searchDirs := [searchDirs]
        }
        
        this.searchDirs := searchDirs
        this.fileSuffix := fileSuffix
        this.recursive := recursive
    }

    LoadServiceDefinitions() {
        if (!this.services) {
            this.DiscoverDefinitions()
        }

        return this.services
    }

    LoadParameterDefinitions() {
        if (!this.parameters) {
            this.DiscoverDefinitions()
        }

        return this.parameters
    }

    DiscoverDefinitions() {
        this.services := Map()
        this.parameters := Map()

        options := this.recursive ? "FR" : "F"

        for index, dir in this.searchDirs {
            Loop Files dir . "\*" . this.fileSuffix, options {
                baseName := SubStr(A_LoopFileName, 1, -StrLen(this.fileSuffix))

                for key, val in this.DiscoverServiceDefinitions(baseName, A_LoopFileName, A_LoopFileFullPath) {
                    this.services[key] := val
                }

                for key, val in this.DiscoverParameterDefinitions(baseName, A_LoopFileName, A_LoopFileFullPath) {
                    this.parameters[key] := val
                }
            }
        }
    }

    DiscoverServiceDefinitions(baseName, fileName, filePath) {
        return Map()
    }

    DiscoverParameterDefinitions(baseName, fileName, filePath) {
        return Map()
    }
}
