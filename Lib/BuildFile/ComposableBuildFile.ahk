class ComposableBuildFile extends BuildFile {
    Build() {
        base.Build()
        this.Delete()
        this.ComposeFile()
        this.Cleanup()
    }

    ComposeFile() {

    }
}
