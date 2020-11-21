class ComposableBuildFile extends BuildFile {
    Build() {
        super.Build()
        this.Delete()
        result := this.ComposeFile()
        this.Cleanup()

        return result
    }

    ComposeFile() {
        return this.FilePath
    }
}
