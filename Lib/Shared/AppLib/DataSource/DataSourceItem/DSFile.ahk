class DSFile extends DataSourceItemBase {
    allowRead := true ; Some files are only meant to be copied

    Read() {
        return this.allowRead ? super.Read() : ""
    }
}
