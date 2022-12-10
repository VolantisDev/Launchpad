class DiffResult {
    added := ""
    modified := ""
    deleted := ""
    
    __New(added, modified, deleted) {
        this.added := added
        this.modified := modified
        this.deleted := deleted
    }

    static Combine(diffs) {
        added := Map()
        modified := Map()
        deleted := Map()

        for index, diff in diffs {
            for key, item in diff.GetAdded() {
                if (!added.Has(key) && !modified.Has(key) && !deleted.Has(key)) {
                    added[key] := item
                }
            }

            for key, item in diff.GetModified() {
                if (!added.Has(key) && !modified.Has(key) && !deleted.Has(key)) {
                    modified[key] := item
                }
            }

            for key, item in diff.GetDeleted() {
                if (!added.Has(key) && !modified.Has(key) && !deleted.Has(key)) {
                    deleted[key] := item
                }
            }
        }

        return DiffResult(added, modified, deleted)
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
