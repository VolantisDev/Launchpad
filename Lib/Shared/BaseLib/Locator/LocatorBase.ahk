class LocatorBase {
    __New(config := "") {
        if (Type(config) == "Map") {
            for key, val in config {
                this.%key% := val
            }
        }
    }

    Locate(pattern) {
        return []
    }
}
