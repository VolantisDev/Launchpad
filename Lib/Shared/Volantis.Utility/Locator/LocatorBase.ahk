class LocatorBase {
    __New(config := "") {
        if (HasBase(config, Map.Prototype)) {
            for key, val in config {
                this.%key% := val
            }
        }
    }

    Locate(pattern) {
        return []
    }
}
