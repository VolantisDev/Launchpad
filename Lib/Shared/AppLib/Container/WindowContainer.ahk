class WindowContainer extends ContainerBase {
    Get(key) {
        window := super.Get(key)

        if (!window) {
            throw WindowNotFoundException("Window '" . key . "' does not exist")
        }

        return window
    }
}
