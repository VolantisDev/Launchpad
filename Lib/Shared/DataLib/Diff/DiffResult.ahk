class DiffResult {
    added := ""
    modified := ""
    deleted := ""
    
    __New(added, modified, deleted) {
        this.added := added
        this.modified := modified
        this.deleted := deleted
    }

    HasChanges() {
        return this.CountAdded() > 0 || this.CountModified() > 0 || this.CountDeleted() > 0
    }

    ValueIsModified(key) {
        return this.added.Has(key) || this.modified.Has(key) || this.deleted.Has(key)
    }

    GetAdded() {
        return this.added
    }

    GetModified() {
        return this.modified
    }

    GetDeleted() {
        return this.deleted
    }

    CountAdded() {
        return this.added.Count
    }

    CountModified() {
        return this.modified.Count
    }

    CountDeleted() {
        return this.deleted.Count
    }
}
