#Include JsonItem.ahk

class ApiListing extends JsonItem {
    __New(app, path) {
        super.__New(app, "index", path)
    }
}
