class IncludeBuilderBase {
    basePaths := ""
    filePattern := "*"
    recursive := true
    removeBase := false
    excludeExtensions := ""
    includeExtensions := ""
    
    __New(basePaths, filePattern := "", recursive := true, removeBase := false, excludeExtensions := "", includeExtensions := "") {
        if (!HasBase(basePaths, Array.Prototype)) {
            basePaths := [basePaths]
        }
        
        this.basePaths := basePaths

        if (filePattern) {
            this.filePattern := filePattern
        }

        this.recursive := recursive
        this.removeBase := removeBase

        if (excludeExtensions) {
            if (!HasBase(excludeExtensions, Array.Prototype)) {
                excludeExtensions := [excludeExtensions]
            }

            this.excludeExtensions := excludeExtensions
        }

        if (includeExtensions) {
            if (!HasBase(includeExtensions, Array.Prototype)) {
                includeExtensions := [includeExtensions]
            }

            this.includeExtensions := includeExtensions
        }
    }

    BuildIncludes() {
        includes := []

        options := this.recursive ? "FR" : "F"

        for index, basePath in this.basePaths {
            Loop Files basePath . "/" . this.filePattern, options {
                filePath := A_LoopFileFullPath

                if (this.ShouldInclude(filePath)) {
                    if (this.removeBase) {
                        filePath := StrReplace(filePath, basePath . "\", "")
                    }

                    includes.Push(filePath)
                }
            }
        }

        return includes
    }

    ShouldInclude(path) {
        shouldInclude := true

        if (this.includeExtensions) {
            shouldInclude := false

            for index, extension in this.includeExtensions {
                extLen := StrLen(extension)

                if (SubStr(path, -extLen) == extension) {
                    shouldInclude := true
                    break
                }
            }
        }

        if (shouldInclude && this.excludeExtensions) {
            for index, extension in this.excludeExtensions {
                extLen := StrLen(extension)

                if (SubStr(path, -extLen) == extension) {
                    shouldInclude := false
                    break
                }
            }
        }

        return shouldInclude
    }
}
