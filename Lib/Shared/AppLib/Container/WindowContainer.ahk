class WindowContainer extends ContainerBase {
    Get(key) {
        window := super.Get(key)

        if (!window) {
            throw WindowNotFoundException.new("Window '" . key . "' does not exist")
        }

        return window
    }
}
