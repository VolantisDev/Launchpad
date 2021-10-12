class ExternalModuleBase {
    IsCore() {
        return false
    }

    GetVersion() {
        version := ""

        if (this.moduleInfo.Has("version")) {
            version := this.moduleInfo["version"]
        }

        return version
    }
}
