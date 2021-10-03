class IncludeBuilderBase {
    basePaths := ""
    filePattern := "*"
    recursive := true
    removeBase := false
    excludeExtensions := []
    
    __New(basePaths, filePattern := "", recursive := true, removeBase := false, excludeExtensions := "") {
        if (Type(basePaths) != "Array") {
            basePaths := [basePaths]
        }
        
        this.basePaths := basePaths

        if (filePattern) {
            this.filePattern := filePattern
        }

        this.recursive := recursive
        this.removeBase := removeBase

        if (excludeExtensions) {
            if (Type(excludeExtensions) != "Array") {
                excludeExtensions := [excludeExtensions]
            }

            this.excludeExtensions := excludeExtensions
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

        for index, extension in this.excludeExtensions {
            extLen := StrLen(extension)

            if (SubStr(path, -extLen) == extension) {
                shouldInclude := false
                break
            }
        }

        return shouldInclude
    }
}
