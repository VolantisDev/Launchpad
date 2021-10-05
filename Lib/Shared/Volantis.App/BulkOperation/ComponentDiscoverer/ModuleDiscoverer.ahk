class ModuleDiscoverer extends ClassFileComponentDiscoverer {
    coreModuleParentDirs := ""

    __New(componentManager, searchDirs, coreModuleParentDirs := "", owner := "") {
        this.coreModuleParentDirs := coreModuleParentDirs

        super.__New(componentManager, searchDirs, "*.module.ahk", owner)    
    }

    PopulateComponentInfo(fileName, filePath) {
        info := super.PopulateComponentInfo(fileName, filePath)
        info["core"] := this.IsCoreModule(fileName, filePath)
    }

    IsCoreModule(fileName, filePath) {
        isCore := false

        if (this.coreModuleParentDirs) {
            for index, parentDir in this.coreModuleParentDirs {
                coreLen := StrLen(parentDir)
                if (SubStr(filePath, 1, coreLen) == parentDir) {
                    isCore := true
                    break
                }
            }
        }

        return isCore
    }
}
