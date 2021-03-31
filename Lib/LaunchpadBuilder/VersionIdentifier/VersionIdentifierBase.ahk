class VersionIdentifierBase {
    app := ""

    __New(app) {
        this.app := app
    }

    IdentifyVersion(defaultVersion := "") {
        throw MethodNotImplementedException.new("VersionIdentifierBase", "IdentifyVersion")
    }
}
