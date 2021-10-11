class DialogBox extends FormGuiBase {
    GetDefaultConfig(container, config) {
        defaults := super.GetDefaultConfig(container, config)
        defaults["buttons"] := "*&Yes|&No"
        return defaults
    }
}
