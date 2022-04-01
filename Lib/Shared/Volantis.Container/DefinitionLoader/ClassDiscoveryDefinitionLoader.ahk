class ClassDiscoveryDefinitionLoader extends DefinitionLoaderBase {
    searchDirs := ""
    fileSuffix := ""
    classSuffix := ""
    recursive := ""
    services := ""
    parameters := ""


    __New(searchDirs, fileSuffix := "", classSuffix := "", recursive := false) {
        if (!HasBase(searchDirs, Array.Prototype)) {
            searchDirs := [searchDirs]
        }
        
        this.searchDirs := searchDirs
        this.fileSuffix := fileSuffix
        this.classSuffix := classSuffix
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
                for key, val in this.DiscoverServiceDefinitions(A_LoopFileName, A_LoopFileFullPath) {
                    this.services[key] := val
                }

                for key, val in this.DiscoverParameterDefinitions(A_LoopFileName, A_LoopFileFullPath) {
                    this.parameters[key] := val
                }
            }
        }
    }

    DiscoverServiceDefinitions(fileName, filePath) {
        return Map(
            this.getServiceName(fileName, filePath), Map(
                "class", this.getClassName(fileName, filePath),
                "file", A_LoopFileFullPath
            )
        )
    }

    DiscoverParameterDefinitions(fileName, filePath) {
        return Map()
    }

    getServiceName(fileName, filePath) {
        serviceName := fileName

        if (this.fileSuffix) {
            serviceName := SubStr(serviceName, 1, -StrLen(this.fileSuffix))
        }

        return serviceName
    }

    getClassName(fileName, filePath) {
        className := fileName

        if (this.fileSuffix) {
            className := SubStr(className, 1, -StrLen(this.fileSuffix))
        }

        if (this.classSuffix) {
            className .= this.classSuffix
        }

        return className
    }
}
