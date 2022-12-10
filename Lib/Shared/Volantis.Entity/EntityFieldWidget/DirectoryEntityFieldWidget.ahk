class DirectoryEntityFieldWidget extends LocationEntityFieldWidgetBase {
    GetDefaultDefinition(definition) {
        defaults := super.GetDefaultDefinition(definition)
        defaults["showOpen"] := true
        return defaults
    }
}
