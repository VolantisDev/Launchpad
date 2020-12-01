class ComposableBuildFile extends BuildFileBase {
    Build() {
        this.Delete()
        result := this.ComposeFile()
        this.Cleanup()

        return result
    }

    ComposeFile() {
        throw MethodNotImplementedException.new("ComposableBuildFile", "ComposeFile")
    }
}
